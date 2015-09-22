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
    new_topic = params['plan']['topic']
    new_language = params['plan']['language']
    name = "#{Time.now.year}/#{Time.now.month}/#{Time.now.day} #{new_language} #{new_topic}"
    new_plan = @user.plans.new(frequency: 1, topic: new_topic, language: new_language, cards_per_serve: 5, serves: 5, name: name)
    new_plan.save

    # q = "q=#{new_topic}+language:#{new_language}"
    # puts '*************************'
    # puts q
    # puts new_plan.language
    # puts '*************************'

    # @data = Octokit.search_repos(q)


    if new_topic.length > 1
      topic = new_topic + '+'
    else
      topic = ''
    end
    q = "#{topic}language:#{new_language}"
    puts '***************************************************'
    puts q
    puts '***************************************************'
    @data = Octokit.search_repos(q, per_page: 100)
    # puts '*************************'
    # p "Data: #{@data.items}"
    # puts '*************************'
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
  end

end
