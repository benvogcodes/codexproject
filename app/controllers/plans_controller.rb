class PlansController < ApplicationController
  def index
  end

  def new

  end

  # def testnew
  #
  # end

  # def create
  # end

  def create
    @user = get_current_user
    @data = params

    new_plan = @user.plans.new(frequency: 1, topic: params['topic'], cards_per_serve: 5, serves: 5)
    new_plan.language = params['language']
    new_plan.save

    q = "q=#{params['topic']}+language:#{params['language']}"
    @data = Octokit.search_repos(q)
    @data = new_plan.create_plan(@data.items, @user)

    render json: @data
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def createplan
    @repositories = params[:repos]
    @repositories.each do |repository|
      puts "*" * 100
      # fetching property example
      p repository[1]['full_name']
    end
    redirect_to root_path
  end
end
