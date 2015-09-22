module TwilioHelper
  require 'rubygems' # not necessary with ruby 1.9 but included for completeness
  require 'twilio-ruby'

  # put your own credentials here
  def send_twilio_notification(recipient, sender, message_body)
    account_sid = ENV['TWILIO_SID']
    auth_token = ENV['TWILIO_TOKEN']

    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token

    @client.account.messages.create({
      :to => recipient,
      :from => sender,
      :body => message_body
    })
  end
end
