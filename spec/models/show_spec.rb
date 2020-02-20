require 'rails_helper'

RSpec.describe Show, :type => :model do

  before do
    Host.destroy_all
    Guest.destroy_all
    Show.destroy_all
    Interview.destroy_all
  end

  it "is valid with a title, description, category, url, and duration" do
    podcast = Show.create(title:"show-pod", description:"something", category:"anything", url:"something.io", duration:"1 hour")

    expect(podcast).to be_valid
  end

  it "is not valid without a title" do
    expect(Show.new(description:"Something", category:"Anything", url:"blahblah.com", duration:"20 mins")).not_to be_valid
  end

  it "is not valid without a description" do
    expect(Show.new(title:"Yadda Yadda", category:"Tech News", url:"yada.show", duration:"45 mins")).not_to be_valid
  end

  it "is not valid without a category" do
    expect(Show.new(title:"Bob's Show", description:"I just yammer", url:"whocares.net", duration:"2 hours")).not_to be_valid
  end

  it "is not valid without a url" do
    expect(Show.new(title:"Chair Pod", description:"We talk about chairs", category:"Conversational", duration:"60 mins")).not_to be_valid
  end

  it "is not valid without a duration" do
    expect(Show.new(title:"Coffee Pod", description:"coffee, Coffee, COFFEE!!", category:"Food", url:"coffee-pod.eu")).not_to be_valid
  end

  it "is valid with a unique title" do
    podcast = Show.create(title:"show-pod", description:"something", category:"anything", url:"something.io", duration:"1 hour")
    podcast2 = Show.new(title:"show-pod", description:"Something different", category:"NERDS", url:"h2o.net", duration:"30 minutes")
    
    expect(podcast2).not_to be_valid
  end

  it "is valid with a unique url" do
    podcast = Show.create(title:"show-pod", description:"something", category:"anything", url:"something.io", duration:"1 hour")
    podcast3 = Show.new(title:"Standing Chair Pod", description:"We stand & talk chairs", category:"Weird", url:"something.io", duration:"1 hour")
    
    expect(podcast3).not_to be_valid
  end

  it "belongs to a host" do
    host = Host.create(:name => "John",:email => "john@example.com",:password => "password")
    podcast = Show.create(title:"show-pod", description:"something", category:"anything", url:"something.io", duration:"1 hour")
    podcast_2 = Show.create(title:"Pod-thing", description:"Whatever", category:"Pop Culture", url:"whatever.net", duration:"20 mins")
    host.shows << podcast
    host.shows << podcast_2
    expect(host.shows.last).to eq(podcast_2)
  end

  it "has many interviews" do
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

  it "has many guests through interviews" do
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
    expect(podcast.interviews.first.guest).to eq(guest1)
    expect(podcast.interviews.last.guest).to eq(guest2)
  end
end
