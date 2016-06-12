class Plan < ActiveRecord::Base
  belongs_to :user
  has_many :repos, dependent: :destroy
  has_many :servings, dependent: :destroy
  validates :user_id, presence: true
  validates :frequency, presence: true

  def create_plan(data, _user)
    items = clean_data(data)
  end

  # Parses the important information from the response object from the Github API call.
  def clean_data(data)
    result = []
    items = data || []
    number_of_cards = cards_per_serve
    number_of_deliveries = serves
    make_cards_and_repos(result, items, number_of_cards, number_of_deliveries)
    result.sort! { |a, b| a.stars <=> b.stars }
  end

  # Creates a new repo object tied to a particular plan.
  def build_card(item, plan)
    card = plan.repos.new(
      served: false,
      size: item.size,
      desc: item['description'],
      url: item['html_url'],
      name: item['name'],
      user: item['user'],
      created: item['created'],
      updated: item['updated'],
      pushed: item['pushed'],
      watchers: item['watchers']
    )
    card.stars = item['stars'] || 0
    card.forks = item['forks'] || 0

    card.save
    card
  end

  def current_cards
    cards = []
    servings.each do |serving|
      cards << Repo.find(serving.repo_id) if serving.delivery == served
    end
    cards
  end

  def prev_cards
    cards = []
    servings.each do |serving|
      cards << Repo.find(serving.repo_id) if serving.delivery < served
    end
    cards
  end

  private

  # Creates serving objects tied to a particular plan.
  def build_servings(repositories, plan, num)
    result = []

    repositories.each do |repository|
      new_serving = plan.servings.new(repo_id: repository.id, delivery: num)
      result << new_serving if new_serving.save
    end

    result
  end

  # Need to extract another method from this, dual responsibility.
  def make_cards_and_repos(result, items, number_of_cards, number_of_deliveries)
    number_of_deliveries.times do |j|
      result = []
      number_of_cards.times do |_i|
        unless items.empty?
          item = items.slice!(rand(0..(items.length - 1)))
          new_card = parse_item_details(item)
          # Create a new repo object tied to this plan based on the input hash created above.
          finalized_card = build_card(new_card, self)
        end
        result << finalized_card if finalized_card
      end
      # Creates serving objects tied to this plan, containing the repo objects created above.
      build_servings(result, self, j)
    end
  end

  def parse_item_details(item)
    { 'id' => item.id,
      'name' => item.name,
      'full_name' => item.full_name,
      'url' => item.url,
      'html_url' => item.html_url,
      'description' => trim_description(item.description),
      'created' => item.created_at,
      'updated' => item.updated_at,
      'pushed' => item.pushed_at,
      'size' => item.size,
      'stars' => item.stargazers_count,
      'watchers' => item.watchers_count,
      'forks' => item.forks_count,
      'score' => item.score,
      'user' => item.owner.login }
  end

  # Truncate repo description if longer than 255 chars.
  def trim_description(description)
    description = description.slice(0, 255) + '...' unless description.length <= 255
    description
  end
end
