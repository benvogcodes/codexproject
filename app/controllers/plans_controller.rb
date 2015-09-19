class PlansController < ApplicationController
  def index
  end

  def new
  end

  def create
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
