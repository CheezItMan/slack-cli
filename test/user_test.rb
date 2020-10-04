require_relative 'test_helper'

describe User do
  before do
    @slack_id = "ABC123"
    @name = "tofu"
    @real_name = "Tofu Le"
    @status_text = "brb"
    @user = User.new(slack_id: @slack_id, name: @name, real_name: @real_name, status_text: @status_text)
  end
  
  describe "Constructor"  do
    it "can construct a User instance" do
      expect(@user).must_be_instance_of User
    end
    
    it "can access slack_id, name, real name and status text attributes" do
      expect(@user.name).must_equal @name
      expect(@user.slack_id).must_equal @slack_id
      expect(@user.real_name).must_equal @real_name
      expect(@user.status_text).must_equal @status_text
    end
  end
  
  describe "#details method" do 
    it "returns a String" do
      expect(@user.details).must_be_instance_of String
      expect(@user.details).must_equal "Username: #{@name}, Real name: #{@real_name}, Slack id: #{@slack_id}"
    end   
  end
  
  describe ".list method" do
    it 'returns a list of user instances' do
      VCR.use_cassette('User_list') do
        expect(User.list).must_be_instance_of Array
        expect(User.list.sample).must_be_instance_of User
      end
    end
  end
end
