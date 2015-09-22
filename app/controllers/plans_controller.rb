class PlansController < ApplicationController

  def index
    @user = current_user
    @plans = @user.plans
  end

  def new

  end

  def create
    puts '*************************************'
    puts params
    puts '*************************************'


    @user = current_user
    @data = params

    name = "#{Time.now.year}/#{Time.now.month}/#{Time.now.day} #{params['plan']['language']} #{params['plan']['topic']}"
    new_plan = @user.plans.new(frequency: 1, topic: params['plan']['topic'], cards_per_serve: 5, serves: 5, name: name, twilio: false, sendgrid: false)
    new_plan.language = params['plan']['language']
    new_plan.save


    if params['plan']['topic'].length > 1
      topic = params['plan']['topic'] + '+'
    else
      topic = ''
    end
    q = "#{topic}language:#{params['plan']['language']} stars:>100"
    puts '***************************************************'
    puts q
    puts '***************************************************'
    Octokit.auto_paginate = true
    @data = Octokit.search_repos(q, {sort: 'stars', order: 'desc'})

    @data = new_plan.create_plan(@data.items, @user)

<<<<<<< HEAD
    # puts '*************************'
    # p @data
    # puts '*************************'

    @message_body = "Greetings from Team Codex, #{@user.username}! Your new plan \'#{name}\' has been created. Login to check it out!"

    send_twilio_notification("+12026572604", "+12027190379", @message_body)

=======
>>>>>>> 40661e5b69c40c3eb9aa75d3c543ec3865c80a28
    redirect_to action: "show", id: new_plan.id
  end

  def show
    @plan = Plan.find_by(id: params[:id])
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

  private
    def plan_params
      params.require(:plan).permit(:name,:frequency,:twilio,:sendgrid)
    end

end
