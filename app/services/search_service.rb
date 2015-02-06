class SearchService

  def self.sync_search_vector!(discussion_id)
    SearchVector.where(discussion_id: discussion_id).delete_all

    SearchVector.execute_search_query(
      SearchAlgorithms.sync_search_vector,
      id: discussion_id
    )
  end

  def self.search_for(query, user: nil, limit: 10)
    return [] if (visible_ids = visible_results_for(user)).empty?

    SearchVector.execute_search_query(
      SearchAlgorithms.search(visible_ids),
      query: query,
      limit: limit
    ).map { |result| build_search_result result }
  end

  private

  def self.visible_results_for(user)
    Queries::VisibleDiscussions.new(user: user).pluck(:id)
  end

  def self.build_search_result(result)
    SearchResult.new(result['id'],
                     result['query'],
                     result['rank'],
                     result['blurb'],
                     relevant_motions(result['id'], result['query']),
                     relevant_comments(result['id'], result['query']))
  end

  def self.relevant_motions(discussion_id, query, limit: 2)
    SearchVector.execute_search_query(
      SearchAlgorithms.relevant_motions,
      id: discussion_id,
      query: query,
      limit: limit
    ).map { |result| SearchResultChild.new :motion, result['id'], result['blurb'] }
  end

  def self.relevant_comments(discussion_id, query, limit: 2)
    SearchVector.execute_search_query(
      SearchAlgorithms.relevant_comments,
      id:    discussion_id,
      query: query,
      limit: limit
    ).map { |result| SearchResultChild.new :comment, result['id'], result['blurb'] }
  end

end
