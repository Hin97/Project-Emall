class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include TradesHelper
  include PaymentsHelper
  include UsersHelper
end
