class Admin::ApplicationController < ApplicationController
  before_action :authorize_admin!

  private

  def authorize_admin!
    authenticate_user!

    unless current_user.admin?
      redirect_to root_path, alert: "You must be an admin to do that."
    end
  end
end
