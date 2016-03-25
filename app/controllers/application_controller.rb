require 'sendgrid-ruby'

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

  def send_email(user, plan)
    client = SendGrid::Client.new(api_user: ENV['SENDGRID_USERNAME'], api_key: ENV['SENDGRID_PASSWORD'])
    mail = SendGrid::Mail.new do |m|
      m.to = params['plan'][:email]
      m.from = 'teamcodex11@gmail.com'
      m.subject = "Your New Plan is Ready"
      m.text = "Greetings from Team Codex, #{user.username}! Your new plan #{plan.name} has been created. Login to check it out!"
    end
    client.send(mail)
  end

  def create_query(topic)
    q = "#{topic}language:#{params['plan']['language']} stars:>100 pushed:>#{DateTime.now - 18.months}"
    authenticate_github
    Octokit.auto_paginate = false
    @data = Octokit.search_repos(q, {sort: 'stars', order: 'desc', per_page: 100, page: 1})
  end

  def generate_name(params)
    "#{(params['plan']['language']).capitalize} #{(params['plan']['topic']).capitalize} -  #{Time.now.month}/#{Time.now.day}/#{Time.now.year}"
  end

  def normalize_topic(params)
    if params['plan']['topic'].length > 1
      topic = params['plan']['topic'] + '+'
    else
      topic = ''
    end
  end
end
