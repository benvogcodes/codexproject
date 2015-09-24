require 'sendgrid-ruby'
require 'pry'
class PlansController < ApplicationController

  def index
    @user = current_user
    @plans = @user.plans
  end

  # def email
  #     #
  #   # As a hash
  #   p ENV['SENDGRID_USERNAME']
  #   p ENV['SENDGRID_PASSWORD']
  #   client = SendGrid::Client.new(api_user: ENV['SENDGRID_USERNAME'], api_key: ENV['SENDGRID_PASSWORD'])
  #
  #   p client
  #   mail = SendGrid::Mail.new do |m|
  #
  #   m.to = params[:email]
  #   m.from = 'jxu011@ucr.com'
  #   m.subject = "Your New Plan is Ready"
  #   m.text = "Greetings from Team Codex, #{@user.username}! Your new plan #{new_plan} has been created. Login to check it out!"
  #   end
  #   puts client.send(mail)
  #   redirect_to plans_path
  # end

  def new

  end

  def create
    if params['plan']['language'] == '' && params['plan']['topic'] == ''
      flash[:error] = "Please fill out one of the fields"
      render 'new'
    else
      @user = current_user

      name = "#{params['plan']['language']} #{params['plan']['topic']} #{Time.now.month}/#{Time.now.day}/#{Time.now.year}"
      new_plan = @user.plans.create(frequency: 1, topic: params['plan']['topic'],
                                 cards_per_serve: 5, serves: 5, name: name,
                                 twilio: false, sendgrid: false,
                                 language: params['plan']['language'], served: 0)
        if params['plan']['topic'].length > 1
          topic = params['plan']['topic'] + '+'
        else
          topic = ''
        end

      create_query(topic)
      @data = new_plan.create_plan(@data.items, @user)

      @message_body = "Greetings from Team Codex, #{@user.username}! Your new plan #{new_plan} has been created. Login to check it out!"
      @phone_number = params['plan'][:phone_number].gsub!(/[- ()]/, '')
      send_twilio_notification(@phone_number, "+12027190379", @message_body) if params['plan']['twilio'] == 't'
      if params['plan']['sendgrid'] == 't'
        client = SendGrid::Client.new(api_user: ENV['SENDGRID_USERNAME'], api_key: ENV['SENDGRID_PASSWORD'])
        mail = SendGrid::Mail.new do |m|
        m.to = params['plan'][:email]
        m.from = 'jxu011@ucr.com'
        m.subject = "Your New Plan is Ready"
        m.text = "Greetings from Team Codex, #{@user.username}! Your new plan #{new_plan.name} has been created. Login to check it out!"
        end
        puts client.send(mail)
      end
      redirect_to action: "show", id: new_plan.id
    end
  end

  def show_redirect
    @plan = @user.plans.last
    redirect_to action: "show", id: @plan.id
  end

  def show
    @plan = Plan.find_by(id: params[:id])
    @current_cards = []
    @prev_cards = []

    servings = @plan.servings
    servings.each do |serving|
      if serving.delivery == @plan.served
        card = Repo.find(serving.repo_id)
        @current_cards << card
      elsif serving.delivery < @plan.served
        card = Repo.find(serving.repo_id)
        @prev_cards << card
      end
    end
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
    @plan = Plan.find(params[:id])
    @plan.served += 1
    # send mail
    # send text
    # redirect to show page
  end

  private
    def create_query(topic)
      q = "#{topic}language:#{params['plan']['language']} stars:>100 pushed:>#{DateTime.now - 18.months}"
      authenticate_github
      Octokit.auto_paginate = false
      @data = Octokit.search_repos(q, {sort: 'stars', order: 'desc', per_page: 100, page: 1})
    end

    def plan_params
      params.require(:plan).permit(:name,:frequency,:twilio,:sendgrid, :topic)
    end

end
