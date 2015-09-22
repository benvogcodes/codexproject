require 'sendgrid-ruby'

class PlansController < ApplicationController
  def index

  end

  def email
      #
    # As a hash
    p ENV['SENDGRID_USERNAME']
    p ENV['SENDGRID_PASSWORD']
    client = SendGrid::Client.new(api_user: ENV['SENDGRID_USERNAME'], api_key: ENV['SENDGRID_PASSWORD'])

    # Or as a block
    # client = SendGrid::Client.new do |c|
    #   c.api_user = 'SENDGRID_USERNAME'
    #   c.api_key = 'SENDGRID_PASSWORD'
    # end
    p client
    mail = SendGrid::Mail.new do |m|

    m.to = params[:to]
    m.from = 'jxu011@ucr.com'
    m.subject = params[:subject]
    m.text = params[:body]
    end
    puts client.send(mail)
    redirect_to plans_path
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


  private
  def plan_params
    params.require(:plan).permit(:topic, :frequency, :topic, :query)
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
