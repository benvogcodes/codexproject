require 'sendgrid-ruby'

namespace :sendgrid_email do
  desc "sends an email via sendgrid"
  task :generate => :environment do
    puts "about to send email"
    client = SendGrid::Client.new(api_user: 'teamcodex', api_key: 'FolsomStreet88')
    mail = SendGrid::Mail.new do |m|

    m.to = 'jxu011@ucr.com'
    m.from = 'jsnx21@gmail.com'
    m.subject = 'implementation of binary search in constant time'
    m.text = 'askldfafjkladsfjklsajflksadjfkl;sajfsdkjldkjaflkdf chacharon chacharon '
    end
    p client
    puts client.send(mail)
  end
end
