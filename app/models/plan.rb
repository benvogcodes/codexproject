class Plan < ActiveRecord::Base
  belongs_to :user
  has_many :repos

  # validates :user_id, presence: true
  # validates :frequency, presence: true
  # validates :query, presence: true

  def create_plan(data, user)
    puts '*********************'
    puts 'create plan started'
    puts user.id
    puts '*********************'
    current_user = User.find(user.id)

    items = self.clean_data(data)
    result = self.build_cards(items, self)
  end

  def clean_data(data)
    result = []
    items = data['items']
    items.each do |item|
      result << {'id' => item[1]['id'],
        'name' => item[1]['name'],
        'full_name' => item[1]['full_name'],
        'url' => item[1]['url'],
        'html_url' => item[1]['html_url'],
        'description' => item[1]['description'],
        'created_at' => item[1]['created_at'],
        'updated_at' => item[1]['updated_at'],
        'pushed_at' => item[1]['pushed_at'],
        'clone_url' => item[1]['clone_url'],
        'size' => item[1]['size'],
        'stargazers_count' => item[1]['stargazers_count'],
        'watchers_count' => item[1]['watchers_count'],
        'forks_count' => item[1]['forks_count'],
        'score' => item[1]['score']
      }
    end
    result
  end

  def build_cards(items, plan)
    result = []
    items.each do |item|
      card = plan.repos.new(served: false, size: item.size, desc: item['description'], url: item['html_url'])
      card.stars = item['stargazers_count'] || 0
      card.forks = item['forks_count'] || 0
      puts '***************'
      puts card['stargazers_count']
      puts '***************'
      result << card if card.save
    end
    result
  end
end
