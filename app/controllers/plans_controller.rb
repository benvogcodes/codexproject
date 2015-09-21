class PlansController < ApplicationController
  def index
  end

  def new

  end

  def create
    @user = current_user
    @data = params
    puts '*************************'
    puts @user.username
    puts @data
    puts '*************************'

    new_plan = @user.plans.new(frequency: 1, topic: params[:topic], cards_per_serve: 5, serves: 5)
    new_plan.language = params[:language]
    new_plan.save

    q = "q=#{params['topic']}+language:#{params[:language]}"
    puts '*************************'
    puts q
    puts params[:language]
    puts new_plan.language
    puts '*************************'

    @data = Octokit.search_repos(q)
    # puts '*************************'
    # p @data.items
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
