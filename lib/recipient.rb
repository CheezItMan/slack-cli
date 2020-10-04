require 'httparty'
require 'dotenv'

class Recipient
  attr_reader :slack_id, :name

  class SlackApiError < Exception; end

  def initialize(slack_id:, name:)
    raise ArgumentError unless (slack_id && name)
    @slack_id = slack_id
    @name = name
  end
 
  def self.list
    raise NotImplementedError, "template method"
  end

  def self.get(url, params)
    response = HTTParty.get(url, query: params)
    raise SlackApiError unless response['ok']

    return response.parsed_response
  end

  def send_message(message)
    Dotenv.load
    
    body = {
      token: ENV["SLACK_API_KEY"],
      text: message,
      channel: slack_id,
    }
    
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    url = "https://slack.com/api/chat.postMessage"
    
    response = HTTParty.post(url, body: body, headers: headers)

    unless response.code == 200 && response["ok"]
      raise SlackApiError, "Invalid sent_message #{response['message']}"
    end

    return true
  end

  def details
    raise NotImplementedError, "template method"
  end
end