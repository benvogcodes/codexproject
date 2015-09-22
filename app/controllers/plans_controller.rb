require 'sendgrid-ruby'

class PlansController < ApplicationController

  def index

  end

  def email
      #
    # As a hash
    p ENV['SENDGRID_USERNAME']
    p ENV['SENDGRID_PASSWORD']
    client = SendGrid::Client.new(api_user: ENV['SENDGRID_USERNAME'], api_key: ENV['SENDGRID_PASSWORD'])

    # Or as a block
    # client = SendGrid::Client.new do |c|
    #   c.api_user = 'SENDGRID_USERNAME'
    #   c.api_key = 'SENDGRID_PASSWORD'
    # end
    p client
    mail = SendGrid::Mail.new do |m|

    m.to = params[:to]
    m.from = 'jxu011@ucr.com'
    m.subject = params[:subject]
    m.text = params[:body]
    end
    puts client.send(mail)
    redirect_to plans_path
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

    new_plan = @user.plans.new(frequency: 1, topic: params['plan']['topic'], cards_per_serve: 5, serves: 5, name: name, twilio: params['plan']['twilio'], sendgrid: params['plan']['sendgrid'])
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

    # puts '*************************'
    # p @data
    # puts '*************************'

    @message_body = "Greetings from Team Codex, #{@user.username}! Your new plan \'#{name}\' has been created. Login to check it out!"

    send_twilio_notification("+12026572604", "+12027190379", @message_body)

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
      params.require(:plan).permit(:name,:frequency,:twilio,:sendgrid, :topic)
    end
end
