require 'sendgrid-ruby'

class PlansController < ApplicationController
  def index
    @user = current_user
    @plans = @user.plans
  end

  def new
  end

  def create
    if params['plan']['language'] == '' && params['plan']['topic'] == ''
      flash[:error] = "Please fill out one of the fields"
      render 'new'
    else
      # Specify user.
      @user = current_user
      # Create new plan for specified user.
      new_plan = @user.plans.create(
          topic: params['plan']['topic'],
          name: generate_name(params),
          language: params['plan']['language'],
        )
      # Normalize query parameters for Github query.
      topic = normalize_topic(params)
      # Fire off call to Github API, returns repo @data for create_plan.
      create_query(topic)
      # Creates repo objects tied to the plan based on the data returned from the Github call.
      @data = new_plan.create_plan(@data.items, @user)
      # Send notifications based on option flags.
      send_twilio_notification(params['plan'][:phone], new_plan) if params['plan']['twilio'] == 't'
      send_email(@user, new_plan) if params['plan']['sendgrid'] == 't'
      # Redirect user to plan_path.
      redirect_to action: "show", id: new_plan.id
    end
  end

  def show_redirect
    @plan = @user.plans.last
    redirect_to action: "show", id: @plan.id
  end

  def show
    @plan = Plan.find_by(id: params[:id])
    @current_cards = @plan.current_cards
    @prev_cards = @plan.prev_cards
  end

  def edit
    @plan = Plan.find_by(id: params[:id])
  end

  def update
    @plan = Plan.find(params[:id])
    redirect_to plan_path(@plan) if @plan.update(plan_params)
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    redirect_to plans_path
  end

  def demo_advance
    @plan = Plan.find(params['plan_id'])
    @plan.served += 1
    @plan.save
    redirect_to @plan
  end

  private

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

  def plan_params
    params.require(:plan).permit(:name,:frequency,:twilio,:sendgrid, :topic)
  end
end
