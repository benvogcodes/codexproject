class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  # Authentication methods
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def get_current_user
    User.find(session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def authenticate_github
    client = Octokit::Client.new(login: ENV['GITHUB_LOGIN'], password: ENV['GITHUB_PASSWORD'])

    user = client.user
    user.login
  end

  def send_twilio_notification(recipient, sender, message_body)
    account_sid = ENV['TWILIO_SID']
    auth_token = ENV['TWILIO_TOKEN']

    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token

    @client.account.messages.create({
      :to => recipient,
      :from => sender,
      :body => message_body
    })
  end
end
