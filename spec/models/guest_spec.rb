require 'rails_helper'

RSpec.describe Guest, :type => :model do

  before do
    Host.destroy_all
    Guest.destroy_all
    Show.destroy_all
    Interview.destroy_all
  end

  it "is valid with a name, email, and expertise" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast
    guest = Guest.create(name:"Bob Weir", email:"bobby@somewhere.com", expertise:"Music")
    interview = guest.build_interview(date:"11/10/2019", show_id:podcast.id, guest_id:guest.id, start_time:"1:00 pm", end_time:"2:00 pm")
    guest.save
    interview.guest_id = guest.id
    interview.save
    podcast.interviews << interview

    expect(guest).to be_valid
  end

  it "is not valid without a name" do
    expect(Guest.new(email:"name@name.com", expertise:"coffee")).not_to be_valid
  end

  it "is not valid without an email" do
    expect(Guest.new(name:"Greg", expertise:"Gardening")).not_to be_valid
  end

  it "belongs to an interview" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast
    guest1 = Guest.create(name:"Bob Weir", email:"bobby@somewhere.com", expertise:"Music")
    guest2 = Guest.create(name:"Jerry Garcia", email:"jerry@darkstar.com", expertise:"Music")
    interview1 = guest1.build_interview(date:"11/10/2019", show_id:podcast.id, guest_id:guest1.id, start_time:"1:00 pm", end_time:"2:00 pm")
    interview2 = guest2.build_interview(date:"11/11/2019", show_id:podcast.id, guest_id:guest2.id, start_time:"1:00 pm", end_time:"2:00 pm")
    guest1.save
    interview1.guest_id = guest1.id
    interview1.save
    guest2.save
    interview2.guest_id = guest2.id
    interview2.save
    podcast.interviews << interview1
    podcast.interviews << interview2

    expect(podcast.interviews.last.guest).to eq(guest2)
  end

  it "is valid with a unique email" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast
    guest = Guest.create(name:"Bob Weir", email:"bobby@somewhere.com", expertise:"Music")
    interview = Interview.create(date: "11/01/2019", show_id: podcast.id, guest_id: guest.id, start_time: "2:00 pm", end_time: "2:30 pm")
    guest2 = Guest.new(name:"Billy", email:"bobby@somewhere.com", expertise:"password")

    expect(guest2).not_to be_valid
  end

end