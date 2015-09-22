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

    # q = "q=#{params['plan']['topic']}+language:#{params['plan']['language']}"
    # puts '*************************'
    # puts q
    # puts params['language']
    # puts new_plan.language
    # puts '*************************'

    # @data = Octokit.search_repos(q)

    # puts '*************************'
    # puts q
    # puts new_plan.language
    # puts '*************************'

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
