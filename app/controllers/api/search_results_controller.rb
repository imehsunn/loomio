class API::SearchResultsController < API::BaseController
  def index
    @search_results = SearchService.search_for(params[:q], user: current_user, limit: 10)
    render json: @search_results
  end
end
