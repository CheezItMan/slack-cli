require_relative 'test_helper'

describe Channel do
  before do
    @slack_id = "ABC123"
    @name = "tofu"
    @topic = "pets"
    @member_count = 2
    @channel = Channel.new(slack_id: @slack_id, name: @name, topic: @topic, member_count: @member_count)
  end
  
  describe "Constructor"  do
    it "can construct a Channel instance" do
      expect(@channel).must_be_instance_of Channel
    end
    
    it "can access slack_id and name attributes" do 
      expect(@channel.name).must_equal @name
      expect(@channel.slack_id).must_equal @slack_id
      expect(@channel.topic).must_equal @topic
      expect(@channel.member_count).must_equal @member_count
    end
  end
  
  describe "#details method" do
    it "returns a String" do
      expect(@channel.details).must_be_instance_of String
      expect(@channel.details).must_equal "Channel's name: #{@name}, Topic: #{@topic}, Slack id: #{@slack_id}, Member count: #{@member_count}"
    end 
  end
  
  describe ".list method" do
    it 'returns a list of channel instances' do
      VCR.use_cassette('Channel_list') do
        expect(Channel.list).must_be_instance_of Array
        expect(Channel.list.sample).must_be_instance_of Channel
      end
    end
  end
end
