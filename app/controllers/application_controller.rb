class ApplicationController < ActionController::Base
  def current_user
    @_current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  end

  def grand_score
    session[:score] = 0
  end
end
