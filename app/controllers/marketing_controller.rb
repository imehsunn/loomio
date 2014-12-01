class MarketingController < ApplicationController
  def index
    if current_user_or_visitor.is_logged_in?
     redirect_to dashboard_path
    elsif show_loomio_org_marketing
     render layout: false
    else
     redirect_to new_user_session_path
    end
  end
end
