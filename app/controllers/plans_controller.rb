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

  def create
    @user = current_user
    @data = params
    name = "#{Time.now.year}/#{Time.now.month}/#{Time.now.day} #{params['language']} #{params['topc']}"
    new_plan = @user.plans.new(frequency: 1, topic: params['topic'], cards_per_serve: 5, serves: 5, name: name)
    new_plan.language = params['language']
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

    if params['topic'].length > 1
      topic = params['topic'] + '+'
    else
      topic = ''
    end
    q = "q=#{topic}language:#{params['language']} stars:>5"
    puts '***************************************************'
    puts q
    puts '***************************************************'
    @data = Octokit.search_repos(q, per_page: 100)
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
