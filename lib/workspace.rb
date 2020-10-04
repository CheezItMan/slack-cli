require_relative 'channel'
require_relative 'user'

class Workspace
  attr_reader :channels, :users, :selected
  
  def initialize
    @channels = Channel.list
    @users = User.list
    @selected = nil
  end
  
  def show_details *recipients
    recipients = [:channels, :users] if recipients.empty?
    
    recipients.each do |recipient|
      puts recipient.capitalize
      puts self.send(recipient).map(&:details).join("\n")
      puts
    end
  end
  
  def select_user name: nil, slack_id: nil
    @selected = find_recipient list: users, name: name, slack_id: slack_id
  end
  
  def select_channel name: nil, slack_id: nil
    @selected = find_recipient list: channels, name: name, slack_id: slack_id
  end
  
  def find_recipient(list:, name: nil, slack_id: nil)
    raise ArgumentError unless name || slack_id
    
    return list.find do |recipient| 
      name ? recipient.name == name : recipient.slack_id == slack_id  
    end 
  end
  
  def send_message
    if selected
      puts "Please enter message to send to #{selected.name}: "
      message = gets.chomp
      raise Recipient::SlackApiError if message.empty?
      
      selected.send_message(message)
    else
      puts "No recipient selected\n\n"
      return false
    end
  end
  
  def show_selected
    puts selected ? selected.details : "No recipient was selected"
    puts
  end
end
