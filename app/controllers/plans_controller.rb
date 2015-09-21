class PlansController < ApplicationController
  def index
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
    new_plan = @user.plans.new(frequency: 1, topic: params['plan']['topic'], cards_per_serve: 5, serves: 5, name: name)
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
    # p @data.items
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
    @data = Octokit.search_repos(q, {sort: 'stars', order: 'desc', per_page: 100})
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
