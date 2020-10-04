require_relative 'recipient'
require 'dotenv'

class Channel < Recipient
  attr_reader :topic, :member_count

  def initialize(slack_id:, name:, topic:, member_count:)
    super(slack_id: slack_id, name: name)
    @topic = topic
    @member_count = member_count
  end

  def self.list
    Dotenv.load
    params = { token: ENV['SLACK_API_KEY'] }

    response = self.get('https://slack.com/api/conversations.list', params)

    response['channels'].map do |channel|
      channel_info = { slack_id: channel['id'], 
        name: channel['name'],
        topic: channel['topic']['value'],
        member_count: channel['num_members']
      }
      self.new(channel_info) 
    end
  end

  def details
    return "Channel's name: #{name}, Topic: #{topic}, Slack id: #{slack_id}, Member count: #{member_count}"
  end
end