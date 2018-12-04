module Accounts
  class BaseController < ApplicationController
    layout 'account/application'
    before_action :authenticate_user!
    # skip_before_action :authenticate_user!
    def index
      @current_account ||= Account.find_by!(subdomain: request.subdomain) 
    end
    helper_method :current_account
   
    def seller?
     current_account.seller == current_user
    end
    helper_method :seller?

  end 
end