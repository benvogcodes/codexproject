class Plan < ActiveRecord::Base
  belongs_to :user
  has_many :repos, dependent: :destroy
  has_many :servings, dependent: :destroy
  validates :user_id, presence: true
  validates :frequency, presence: true

  def create_plan(data, user)
    items = self.clean_data(data)
    result = self.build_cards(items, self)
  end


  def clean_data(data)
    result = []
    items = data || []

    number_of_cards = self.cards_per_serve
    number_of_deliveries = self.serves

    number_of_deliveries.times do |j|

      result = []

      number_of_cards.times do |i|

        if items.length > 0
          item = items.slice!(rand(0..(items.length - 1)))

          new_card = {'id' => item.id,
            'name' => item.name,
            'full_name' => item.full_name,
            'url' => item.url,
            'html_url' => item.html_url,
            'description' => item.description,
            'created' => item.created_at,
            'updated' => item.updated_at,
            'pushed' => item.pushed_at,
            'size' => item.size,
            'stars' => item.stargazers_count,
            'watchers' => item.watchers_count,
            'forks' => item.forks_count,
            'score' => item.score,
            'user' => item.owner.login
          }

          if new_card['description'].length > 255
            new_card['description'] = new_card['description'].slice(0, 255) + '...'
          end

          new_card = build_card(new_card, self)
        end

        result << new_card if new_card
      end

      build_servings(result, self, j)
    end

    result
  end


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


  def build_cards(items, plan)
    result = []

    items.each do |item|
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

      result << card if card.save
    end

    result.sort! { |a,b| a.stars <=> b.stars }
  end


  def build_servings(repositories, plan, num)
    result = []

    repositories.each do |repository|
      new_serving = plan.servings.new(repo_id: repository.id, delivery: num)
      result << new_serving if new_serving.save
    end

    result
  end

  def current_cards
    cards = []
    self.servings.each do |serving|
      cards << Repo.find(serving.repo_id) if serving.delivery == self.served
    end
    cards
  end

  def prev_cards
    cards = []
    self.servings.each do |serving|
      cards << Repo.find(serving.repo_id) if serving.delivery < self.served
    end
    cards
  end
end
