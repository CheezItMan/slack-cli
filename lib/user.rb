require 'dotenv'
require_relative 'recipient'

class User < Recipient
  attr_reader :real_name, :status_text
  
  def initialize(slack_id:, name:, real_name:, status_text:)  
    super(slack_id: slack_id, name: name)
    @real_name = real_name
    @status_text = status_text
  end

  def self.list
    Dotenv.load
    params = { token: ENV['SLACK_API_KEY'] }
    
    response = self.get('https://slack.com/api/users.list', params)
    
    response['members'].map do |user|
      user_info = { slack_id: user['id'], name: user['name'],
                    real_name: user['profile']['real_name'],
                    status_text: user['profile']['status_text'],
                  }
      self.new(user_info) 
    end
  end

  def details
    return "Username: #{name}, Real name: #{real_name}, Slack id: #{slack_id}"
  end
end
