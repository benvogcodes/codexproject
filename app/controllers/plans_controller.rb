class PlansController < ApplicationController
  def index
    @user = current_user
    @plans = @user.plans
  end

  def new

  end

  def create
    @user = current_user
    @data = params

    name = "#{Time.now.year}/#{Time.now.month}/#{Time.now.day} #{params['plan']['language']} #{params['plan']['topic']}"
    new_plan = @user.plans.new(frequency: 1, topic: params['plan']['topic'],
                               cards_per_serve: 5, serves: 5, name: name,
                               twilio: false, sendgrid: false,
                               language: params['plan']['language'])
    new_plan.save

    if params['plan']['topic'].length > 1
      topic = params['plan']['topic'] + '+'
    else
      topic = ''
    end

    q = "#{topic}language:#{params['plan']['language']} stars:>100 pushed:>#{DateTime.now - 18.months}"
    authenticate_github
    Octokit.auto_paginate = true
    @data = Octokit.search_repos(q, {sort: 'stars', order: 'desc'})
    @data = new_plan.create_plan(@data.items, @user)

    redirect_to action: "show", id: new_plan.id
  end

  def show
    @plan = Plan.find_by(id: params[:id])
  end

  def edit
    @plan = Plan.find_by(id: params[:id])
  end

  def update
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.repos.each do |repo|
      repo.destroy
    end
    @plan.destroy
    redirect_to plans_path
  end

end
