class PlansController < ApplicationController
  def index
  end

  def new
  end

  def testnew

  end

  def create
  end

  def testcreate
    @user = User.find(session[:user_id])
    puts '*************************'
    puts @user.id
    puts '*************************'
    @data = params
    new_plan = @user.plans.new(frequency: 'na', topic: 'na', query: 'na')
    new_plan.save
    puts '*************************'
    puts "plan: #{new_plan.id}"
    puts '*************************'
    @data = new_plan.create_plan(@data, @user)

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
