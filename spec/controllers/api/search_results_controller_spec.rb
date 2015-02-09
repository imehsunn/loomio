require 'rails_helper'
describe API::SearchResultsController do

  let(:user)    { create :user }
  let(:group)   { create :group }
  let(:discussion) { create :discussion, group: group }
  let(:active_motion) { create :current_motion, discussion: discussion }
  let(:closed_motion) { create :motion, discussion: discussion, closed_at: 2.days.ago }
  let(:comment) { create :comment, discussion: discussion }

  describe 'index' do
    before do
      group.admins << user
      sign_in user
    end

    it 'does not find irrelevant threads' do
      json = search_for('find')
      discussion_ids = fields_for(json, 'search_results', 'discussion').map { |d| d['id'].to_i }
      expect(@discussion_ids).to_not include discussion.id
    end

    it "can find a discussion by title" do
      DiscussionService.update discussion: discussion, params: { title: 'find me' }, actor: user
      search_for('find')

      expect(@discussion_ids).to include discussion.id
      expect(@priorities).to include 1
    end

    it "can find a discussion by description" do
      DiscussionService.update discussion: discussion, params: { description: 'find me' }, actor: user
      search_for('find')

      expect(@discussion_ids).to include discussion.id
      expect(@priorities).to include 0.2
    end

    it "can find a discussion by active proposal name" do
      active_motion.update name: 'find me'
      SearchService.sync! active_motion.discussion_id
      search_for('find')

      expect(@discussion_ids).to include discussion.id
      expect(@priorities).to include 0.4
    end

    it "can find a discussion by active proposal description" do
      active_motion.update description: 'find me'
      SearchService.sync! closed_motion.discussion_id
      search_for('find')

      expect(@discussion_ids).to include discussion.id
      expect(@priorities).to include 0.2
    end

    it "can find a discussion by closed proposal name" do
      closed_motion.update name: 'find me'
      SearchService.sync! closed_motion.discussion_id
      search_for('find')

      expect(@discussion_ids).to include discussion.id
      expect(@priorities).to include 0.2
    end

    it "can find a discussion by closed proposal description" do
      closed_motion.update description: 'find me'
      SearchService.sync! closed_motion.discussion_id
      search_for('find')

      expect(@discussion_ids).to include discussion.id
      expect(@priorities).to include 0.1
    end

    it "can find a discussion by comment body" do
      comment.update body: 'find me'
      SearchService.sync! comment.discussion_id
      search_for('find')

      expect(@discussion_ids).to include discussion.id
      expect(@priorities).to include 0.1
    end

    it "does not display content the user does not have access to" do
      DiscussionService.update discussion: discussion, params: { group: create(:group) }, actor: user
      search_for('find')

      expect(@discussion_ids).to_not include discussion.id
    end
  end
end

def fields_for(json, name, field)
  json[name].map { |f| f[field] }
end

def search_for(term)
  get :index, q: term, format: :json
  JSON.parse(response.body).tap do |json|
    expect(json.keys).to include *(%w[search_results])
    @discussion_ids = fields_for(json, 'search_results', 'discussion').map { |d| d['id'].to_i }
    @priorities     = fields_for(json, 'search_results', 'priority').map(&:to_f)
  end
end
