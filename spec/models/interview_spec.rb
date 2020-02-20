require 'rails_helper'

RSpec.describe Interview, :type => :model do

  before do
    Host.destroy_all
    Guest.destroy_all
    Show.destroy_all
    Interview.destroy_all
  end

  it "is valid with a date, show_id, guest_id, start time, and end time" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast
    guest = Guest.create(name:"Bob Weir", email:"bobby@somewhere.com", expertise:"Music")
    interview = guest.build_interview(date:"11/10/2019", show_id:podcast.id, guest_id:guest.id, start_time:"1:00 pm", end_time:"2:00 pm")
    guest.save
    interview.guest_id = guest.id
    interview.save

    expect(interview).to be_valid
  end

  it "is not valid without a start time" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast
    guest = Guest.create(name:"Bob Weir", email:"bobby@somewhere.com", expertise:"Music")

    expect(Interview.new(date:"10/01/2019", guest_id:guest.id, show_id:podcast.id, end_time:"3:30 pm")).not_to be_valid
  end

  it "is not valid without an end time" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast
    guest = Guest.create(name:"Bob Weir", email:"bobby@somewhere.com", expertise:"Music")

    expect(Interview.new(date:"10/01/2019", guest_id:guest.id, show_id:podcast.id, start_time:"4:00 pm")).not_to be_valid
  end

  it "is not valid without a date" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast
    guest = Guest.create(name:"Bob Weir", email:"bobby@somewhere.com", expertise:"Music")

    expect(Interview.new(show_id:podcast.id, guest_id:guest.id, start_time:"2:00 pm", end_time:"3:00 pm")).not_to be_valid
  end

  it "defaults to recorded => false" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast
    guest = Guest.create(name:"Bob Weir", email:"bobby@somewhere.com", expertise:"Music")
    interview = Interview.create(date:"11/10/2019", show_id:podcast.id, guest_id:guest.id, start_time:"1:00 pm", end_time:"2:00 pm")

    expect(interview.recorded).to eq(false)
  end

  it "defaults to published => false" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast
    guest = Guest.create(name:"Bob Weir", email:"bobby@somewhere.com", expertise:"Music")
    interview = Interview.create(date:"11/10/2019", show_id:podcast.id, guest_id:guest.id, start_time:"1:00 pm", end_time:"2:00 pm")

    expect(interview.published).to eq(false)
  end

  it "belongs to a show" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast
    guest1 = Guest.create(name:"Bob Weir", email:"bobby@somewhere.com", expertise:"Music")
    guest2 = Guest.create(name:"Phil Lesh", email:"phil@anywhere.com", expertise:"Music")
    interview1 = guest1.build_interview(date:"11/10/2019", show_id:podcast.id, guest_id:guest1.id, start_time:"1:00 pm", end_time:"2:00 pm")
    interview2 = guest2.build_interview(date:"11/11/2019", show_id:podcast.id, guest_id:guest2.id, start_time:"1:00 pm", end_time:"2:00 pm")
    guest1.save
    interview1.guest_id = guest1.id
    interview1.save
    guest2.save
    interview2.guest_id = guest2.id
    interview2.save

    expect(podcast.interviews.last).to eq(interview2)
  end

  it "has one guest" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast
    guest = Guest.create(name:"Bob Weir", email:"bobby@somewhere.com", expertise:"Music")
    interview = guest.build_interview(date:"11/10/2019", show_id:podcast.id, guest_id:guest.id, start_time:"1:00 pm", end_time:"2:00 pm")
    guest.save
    interview.guest_id = guest.id
    interview.save
    
    expect(interview.guest).to eq(guest)
  end
end