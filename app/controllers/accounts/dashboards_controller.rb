module Accounts
  class DashboardsController < Accounts::BaseController
    before_action :authenticate_user!

    def index 
      
    end
    
  end
end