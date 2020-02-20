require 'rails_helper'

RSpec.describe Host, :type => :model do

  before do
    Host.destroy_all
    Guest.destroy_all
    Show.destroy_all
    Interview.destroy_all
  end

  it "is valid with name, email, and password" do
    host = Host.create(:name => "John",:email => "john@example.com",:password => "password")
    expect(host).to be_valid
  end

  it "is not valid without a password" do
    expect(Host.new(name:"name", email:"name@email.com")).not_to be_valid
  end

  it "is not valid without a name" do
    expect(Host.new(email:"name@email.com", password:"password")).not_to be_valid
  end

  it "is not valid without an email" do
    expect(Host.new(name:"name", password:"password")).not_to be_valid
  end

  it "has many shows" do
    host = Host.create(:name => "John",:email => "john@example.com",:password => "password")
    podcast = Show.create(title:"show-pod", description:"something", category:"anything", url:"something.io", duration:"1 hour")
    podcast_2 = Show.create(title:"Pod-thing", description:"Whatever", category:"Pop Culture", url:"whatever.net", duration:"20 mins")
    host.shows << podcast
    host.shows << podcast_2
    expect(host.shows.last).to eq(podcast_2)
  end

  it "has many interviews through shows" do
    host = Host.create(:name => "John",:email => "john@example.com",:password => "password")
    podcast = Show.create(title:"show-pod", description:"something", category:"anything", url:"something.io", duration:"1 hour")
    guest1 = Guest.create(:name => "Bob", :email => "bob@bob.com", :expertise => "Linux")
    guest2 = Guest.create(:name => "James", :email => "james@jimmy.io", :expertise => "Grilling")
    interview1 = guest1.build_interview(date:"11/10/2019", show_id:podcast.id, guest_id:guest1.id, start_time:"1:00 pm", end_time:"2:00 pm")
    interview2 = guest2.build_interview(date:"11/11/2019", show_id:podcast.id, guest_id:guest2.id, start_time:"1:00 pm", end_time:"2:00 pm")
    guest1.save
    interview1.guest_id = guest1.id
    interview1.save
    guest2.save
    interview2.guest_id = guest2.id
    interview2.save
    host.shows << podcast
    podcast.interviews << interview1
    podcast.interviews << interview2
    expect(host.interviews.first).to eq(interview1)
    expect(host.interviews.last).to eq(interview2)
  end

  it "is valid with a unique email" do
    host_1 = Host.create(:name => "John",:email => "john@example.com",:password => "password")
    host1 = Host.new(name:"Phil", email:"john@example.com", password:"password")
    expect(host1).not_to be_valid
  end

end
