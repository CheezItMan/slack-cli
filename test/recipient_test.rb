require_relative 'test_helper'

describe Recipient do
  before do
    @slack_id = "U018931AVTK"
    @name = "chris"
  end

  describe "Constructor"  do
    it "can construct a Recipient instance" do
      expect(Recipient.new(slack_id: @slack_id, name: @name)).must_be_instance_of Recipient
    end
    
    it "can access slack_id and name attributes" do
      recipient = Recipient.new(slack_id: @slack_id, name: @name)
      
      expect(recipient.name).must_equal @name
      expect(recipient.slack_id).must_equal @slack_id
    end

    it "raises ArgumentError if input is invalid" do
      expect {Recipient.new(slack_id: nil, name: nil)}.must_raise ArgumentError
    end
  end
  
  describe "#send_message method" do
    before do
      VCR.use_cassette('workspace') do
        workspace = Workspace.new
        @user = workspace.users.find do |user|
          user.name == "chris"
        end
        @channel = workspace.channels.find do |channel|
          channel.name == "test-channel2"
        end
        @message = 'hello'        
      end
    end
  
    
    it 'can send a message to a channel' do
      VCR.use_cassette('send_message_channel') do
        expect(@channel.send_message(@message)).must_equal true
      end
    end

    it 'can send a message to a user' do
      VCR.use_cassette('send_message_user') do
        expect(@user.send_message(@message)).must_equal true
      end
    end

    it 'raises SlackApiError if response["ok"] is false' do
      VCR.use_cassette('send_failure') do
        channel = Channel.new slack_id: "0", name: "foo", topic: "foo", member_count: 0
        expect { channel.send_message @message }.must_raise Recipient::SlackApiError 
      end
    end
  end
  
  describe ".get method" do
    before do
      Dotenv.load
      @url = 'https://slack.com/api/conversations.list'
      @params = { token: ENV["SLACK_API_KEY"] }
    end
    
    it 'returns a hash' do
      VCR.use_cassette('Recipient_get') do
        response = Recipient.get(@url, @params)
        expect(response).must_be_instance_of Hash
        expect(response['channels']).must_be_instance_of Array
      end
    end

    it "raises SlackApiError if response status is not success" do 
      VCR.use_cassette('Recipient_get_bad_requests') do
        expect {Recipient.get(@url, {})}.must_raise Recipient::SlackApiError
      end
    end
  end
end
