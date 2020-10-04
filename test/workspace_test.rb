require_relative 'test_helper'

describe Workspace do
  before do
    VCR.use_cassette('workspace') do
      @workspace = Workspace.new
    end
  end
  
  describe 'Constructor' do
    it 'can create a Workspace instance' do
      expect(@workspace).must_be_instance_of Workspace
    end
    
    it 'has users, channels and selected' do
      expect(@workspace.channels).must_be_instance_of Array
      expect(@workspace.users).must_be_instance_of Array
      assert_nil(@workspace.selected)
    end
    
    it 'populates users and channels' do
      expect(@workspace.channels.first).must_be_instance_of Channel
      expect(@workspace.users.first).must_be_instance_of User
    end
  end
  
  describe '#select_channel' do
    before do    
      @user_name = "chris"
      @user_id = "U016JEE7Z09"
      @users = @workspace.users
      
      @channel_name = "test-channel2"
      @channel_id = "C01ABK51G14"
      @channels = @workspace.channels
    end
    
    it 'sets @selected to the found channel' do
      @workspace.select_channel name: @channel_name
      channel = @workspace.find_recipient(list: @channels, name: @channel_name)
      
      expect(@workspace.selected).must_equal channel
    end
    
    it 'sets selected to nil if no channel found' do
      @workspace.select_channel name: "TOFU"
      
      assert_nil(@workspace.selected)
    end
  end
  
  describe '#select_user' do
    before do    
      @user_name = "chris"
      @user_id = "U016JEE7Z09"
      @users = @workspace.users
    end
    
    it 'sets @selected to the found user' do
      @workspace.select_user name: @user_name
      user = @workspace.find_recipient(list: @users, name: @user_name)
      
      expect(@workspace.selected).must_equal user
    end
    
    it 'sets selected to nil if no user found' do
      @workspace.select_user name: "TOFU"
      
      assert_nil(@workspace.selected)
    end
  end
  
  describe "#find_recipient" do
    before do
      @user_name = "chris"
      @user_id = "U016JEE7Z09"
      @users = @workspace.users
      
      @channel_name = "test-api-cheezitbot2"
      @channel_id = "C01BX87D1H8"
      @channels = @workspace.channels
    end
    
    it "returns the correct User by slack id or name" do
      user = @workspace.find_recipient(list: @users, name: @user_name)
      
      expect(user).must_be_instance_of User
      expect(user.slack_id).must_equal @user_id
      
      user = @workspace.find_recipient(list: @users, slack_id: @user_id)
      
      expect(user).must_be_instance_of User
      expect(user.name).must_equal @user_name
    end
    
    it "returns the correct Channel by slack id or name" do
      channel = @workspace.find_recipient(list: @channels, name: @channel_name)
      
      expect(channel).must_be_instance_of Channel
      expect(channel.slack_id).must_equal @channel_id
      
      channel = @workspace.find_recipient(list: @channels, slack_id: @channel_id)
      
      expect(channel).must_be_instance_of Channel
      expect(channel.name).must_equal @channel_name
    end
    
    it "raises ArgumentError if both name and slack id aren't provided" do
      expect {@workspace.find_recipient(list: [])}.must_raise ArgumentError
    end
    
    it "returns nil if no recipient found from name or slack id" do
      assert_nil (@workspace.find_recipient(list: @channels, name: "chris"))
      assert_nil (@workspace.find_recipient(list: @users, slack_id: "Tofu2"))
    end
  end
end