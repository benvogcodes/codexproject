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
  end

  def send_twilio_notification(recipient, plan_name)
    @client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
    message_body = "Greetings from Team Codex, #{@user.username}! Your new plan #{plan_name} has been created. Login to check it out!"
    recipient = recipient.gsub!(/[- ()]/, '')
    @client.account.messages.create({
      :to => recipient,
      :from => "+12027190379",
      :body => message_body
    })
  end
end
