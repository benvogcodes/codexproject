class PlansController < ApplicationController
  def index
    require 'sendgrid-ruby'
    # As a hash
    client = SendGrid::Client.new(api_user: 'SENDGRID_USERNAME', api_key: 'SENDGRID_PASSWORD')

    # Or as a block
    client = SendGrid::Client.new do |c|
      c.api_user = 'SENDGRID_USERNAME'
      c.api_key = 'SENDGRID_PASSWORD'
end
  end

  def new

  end

  # def testnew
  #
  # end

  # def create
  # end

  def create
    @user = current_user
    @data = params
    puts '*************************'
    puts @user.username
    puts @data
    puts '*************************'

    new_plan = @user.plans.new(frequency: 1, topic: params['topic'], cards_per_serve: 5, serves: 5)
    new_plan.language = params['language']
    new_plan.save
    puts '*************************'
    puts "plan: #{new_plan.id}"
    puts '*************************'
    #make github api call
    q = "q=#{params['topic']}+language:#{params['language']}"
    puts '*************************'
    puts q
    puts '*************************'

    @data = Octokit.search_repos(q)
    puts '*************************'
    p @data.items
    puts '*************************'

    @data = new_plan.create_plan(@data.items, @user)

    puts '*************************'
    p @data
    puts '*************************'

    redirect_to action: "show", id: new_plan.id
  end

  def show
    @plan = Plan.find_by(id: params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end

  # def createplan
  #   @repositories = params[:repos]
  #   @repositories.each do |repository|
  #     puts "*" * 100
  #     # fetching property example
  #     p repository[1]['full_name']
  #   end
  #   redirect_to root_path
  # end
end
