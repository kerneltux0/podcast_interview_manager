require_relative '../rails_helper.rb'

describe 'Host Signup', :type => :feature do

  before do
    Host.destroy_all
    Guest.destroy_all
    Show.destroy_all
    Interview.destroy_all
  end

  it 'allows a host to signup' do
    visit '/hosts/new'
    expect(page.status_code).to eq(200)
    expect(page).to have_css("h2", text: "New Host Form")
    fill_in "host_name", with: "Jerry Garcia"
    fill_in "host_email", with: "jerry@darkstar.com"
    fill_in "host_password", with: "password"
    click_on "Create Host"
    expect(Host.last.name).to eq("Jerry Garcia")
    expect(Host.last.email).to eq("jerry@darkstar.com")
    expect(response).to redirect_to('/login')
  end

  it "allows a host to use Twitter SSO" do
    visit '/hosts/new'
    expect(page.status_code).to eq(200)
    expect(page).to have_link("Sign in With Twitter")
  end

end

describe "Host Login", :type => :feature do

  before do
    Host.destroy_all
    Guest.destroy_all
    Show.destroy_all
    Interview.destroy_all
  end

  it "allows a host to login after creating an account" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    visit '/login'
    expect(page.status_code).to eq(200)
    expect(page).to have_content("Log in with Twitter or enter your email & password.")
    fill_in "email", with: host.email
    fill_in "password", with: host.password
    click_button("Log in")
    expect(@request.session[:user_id]).to eq(host.id)
    expect(response).to redirect_to(host_path)
  end

  # it "allows a host to login using Twitter SSO" do
  #   visit '/login'
  #   expect(page.status_code).to eq(200)
  #   expect(page).to have_content("Log in with Twitter or enter your email & password.")
  #   expect(page).to have_link("Sign in with Twitter")
  #   click_link("Sign in with Twitter")
  # end

end

describe 'Host Homepage', :type => :feature do

  before do
    Host.destroy_all
    Guest.destroy_all
    Show.destroy_all
    Interview.destroy_all
  end

  it "displays the host's information" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title:"Terrapin Station", description:"Just talk music", category:"Music", url:"something.net", duration:"fluid")
    visit host_path
    expect(page.status_code).to eq(200)
    expect(page).to have_css("h2", text: "Your Information")
    expect(page).to have_content(host.name)
    expect(page).to have_content(host.email)
    expect(page).to have_css("h2", text: "Your Show(s)")
    expect(page).to have_link(podcast.title, href: host_show_path)
  end

  it "allows host to create a new show" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")

    visit new_host_show_path
    expect(page.status_code).to eq(200)
    expect(page).to have_link("Return Home", href: host_path)
    expect(page).to have_css("h2", text: "Create a New Show")
    fill_in "title", with: "Terrapin Station"
    fill_in "description", with: "Just talk music"
    fill_in "category", with: "Music"
    fill_in "url", with: "something.net"
    fill_in "duration", with: "fluid"
    click_button("Create Show")

    expect(host.shows.last.title).to eq("Terrapin Station")
    expect(host.shows.last.description).to eq("Just talk music")
    expect(host.shows.last.category).to eq("Music")
    expect(host.shows.last.url).to eq("something.net")
    expect(host.shows.last.duration).to eq("fluid")
    expect(response).to redirect_to(host_show_path)
  end

end

describe "host's shows page", :type => :feature do

  before do
    Host.destroy_all
    Guest.destroy_all
    Show.destroy_all
    Interview.destroy_all
  end

  it "displays the podcast info" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title:"Terrapin Station", description:"Just talk music", category:"Music", url:"something.net", duration:"fluid")
    host.shows << podcast

    visit host_show_path
    expect(page.status_code).to eq(200)
    expect(page).to have_link("Return Home", href: host_path)
    expect(page).to have_css("h2", text: show.title)
    expect(page).to have_content(podcast.description)
    expect(page).to have_content(podcast.category)
    expect(page).to have_content(podcast.url)
    expect(page).to have_content(podcast.duration)
    expect(page).to have_button("Setup Interview", href: new_host_show_interview_path)
    expect(page).to have_button("Edit Show Details", href: edit_host_show_path)
    expect(page).to have_button("Delete This Show")
  end

  it "displays all interviews for this podcast" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title:"Terrapin Station", description:"Just talk music", category:"Music", url:"something.net", duration:"fluid")
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
    
    visit host_show_path
    expect(page).to have_css("h2", "Interviews for this show")
    expect(page).to have_link("Return Home", href: host_path)
    expect(page).to have_content(interview1.date)
    expect(page).to have_content(interview2.date)
    expect(page).to have_content(interview1.guest.name)
    expect(page).to have_content(interview2.guest.name)
    click_link(interview1.guest.name)
    expect(response).to redirect_to(edit_host_show_interview_path)
  end

  it "allows the host to create new interviews" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title:"Terrapin Station", description:"Just talk music", category:"Music", url:"something.net", duration:"fluid")
    host.shows << podcast

    visit host_show_path
    click_button("Setup Interview")
    expect(response).to redirect_to(new_host_show_interview_path)
  end
end

describe "editing a host's show(s)" do

  before do
    Host.destroy_all
    Guest.destroy_all
    Show.destroy_all
    Interview.destroy_all
  end

  it "renders an edit form" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast

    visit edit_host_show_path
    expect(response).to eq(200)
    expect(page).to have_link("Return Home", href: host_path)
    expect(page).to have_css("h2", text: "Edit #{podcast.title}")
    expect(page).to have_field("show_title", value: "#{podcast.title}")
    expect(page).to have_field("show_description", value: "#{podcast.description}")
    expect(page).to have_field("show_category", value: "#{podcast.category}")
    expect(page).to have_field("show_url", value: "#{podcast.url}")
    expect(page).to have_field("show_duration", value: "#{podcast.duration}")
    expect(page).to have_button("Update Show")
  end

  it "edits the show's details" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast

    visit edit_host_show_path
    expect(response).to eq(200)

    fill_in "show_title", with: "Show Pod"
    fill_in "show_description", with: "darkside something"
    fill_in "show_category", with: "Anything"
    fill_in "show_url", with: "site-some.io"
    fill_in "show_duration", with: "60 mins"
    click_button("Update Show")

    expect(podcast.title).to eq("Show Pod")
    expect(podcast.description).to eq("darkside something")
    expect(podcast.category).to eq("Anything")
    expect(podcast.url).to eq("site-some.io")
    expect(podcast.duration).to eq("60 mins")
    expect(response).to redirect_to(host_show_path)
  end

end

describe "allows host to create a new interview" do

  before do
    Host.destroy_all
    Guest.destroy_all
    Show.destroy_all
    Interview.destroy_all
  end

  it "creates a new interview with a guest" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast
    
    visit new_host_show_interview_path
    expect(response).to eq(200)
    expect(page).to have_link("Return Home", href: host_path)
    expect(page).to have_css("h2", text:"Create Interview for #{podcast.title}")

    fill_in "interview_date", with: "11/01/2019"
    fill_in "interview_start_time", with: "1:00 pm"
    fill_in "interview_end_time", with: "2:00 pm"
    fill_in "interview_guest_name", with: "Phil Lesh"
    fill_in "interview_guest_email", with: "phil@music.net"
    fill_in "interview_guest_expertise", with: "Music"
    click_button("Create Interview")

    expect(podcast.interviews.last.date).to eq("11/01/2019")
    expect(podcast.interviews.last.start_time).to eq("1:00 pm")
    expect(podcast.interviews.last.end_time).to eq("2:00 pm")
    expect(podcast.interviews.last.guest.name).to eq("Phil Lesh")
    expect(podcast.interviews.last.guest.email).to eq("phil@music.net")
    expect(podcast.interviews.last.guest.expertise).to eq("Music")
    expect(response).to redirect_to(host_show_interview_path)
  end

end

describe "allows a host to edit/complete an interview" do

  before do
    Host.destroy_all
    Guest.destroy_all
    Show.destroy_all
    Interview.destroy_all
  end

  it "allows a host to edit an interview's details" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast
    guest = Guest.create(name:"Bob Weir", email:"bobby@somewhere.com", expertise:"Music")
    interview = guest.build_interview(date:"11/10/2019", show_id:podcast.id, guest_id:guest.id, start_time:"1:00 pm", end_time:"2:00 pm")
    guest.save
    interview.guest_id = guest.id
    interview.save
    podcast.interviews << interview

    visit edit_host_show_interview_path
    expect(page.status_code).to eq(200)
    expect(page).to have_field("interview_date", value: "#{interview.date}")
    expect(page).to have_field("interview_start_time", value: "#{interview.start_time}")
    expect(page).to have_field("interview_end_time", value: "#{interview.end_time}")
    fill_in "interview_date", with: "12/10/2019"
    fill_in "interview_start_time", with: "3:00 pm"
    fill_in "interview_end_time", with: "4:00 pm"
    click_button("Update Interview")

    expect(interview.date).to eq("12/10/2019")
    expect(interview.start_time).to eq("3:00 pm")
    expect(interview.end_time).to eq("4:00 pm")
    expect(response).to redirect_to(host_show_interview_path)
  end

  it "allows a host to mark an interview as 'recorded'" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast
    guest = Guest.create(name:"Bob Weir", email:"bobby@somewhere.com", expertise:"Music")
    interview = guest.build_interview(date:"11/10/2019", show_id:podcast.id, guest_id:guest.id, start_time:"1:00 pm", end_time:"2:00 pm")
    guest.save
    interview.guest_id = guest.id
    interview.save
    podcast.interviews << interview

    visit edit_host_show_interview_path
    expect(page.status_code).to eq(200)
    expect(page).to have_link("Return Home", href: host_path)
    find(:css, "#interview_recorded").set(true)
    click_button("Update Interview")
    expect(interview.recorded).to eq(true)
    expect(response).to redirect_to(host_show_interview_path)
  end

  it "allows a host to mark an interview as 'published'" do
    host = Host.create(name:"Jerry Garcia", email:"jerry@darkstar.com", password:"password")
    podcast = Show.create(title: "Pod Show", description: "Something something darkside", category: "Pop Culture", url: "some-site.net", duration: "30 mins")
    host.shows << podcast
    guest = Guest.create(name:"Bob Weir", email:"bobby@somewhere.com", expertise:"Music")
    interview = guest.build_interview(date:"11/10/2019", show_id:podcast.id, guest_id:guest.id, start_time:"1:00 pm", end_time:"2:00 pm")
    guest.save
    interview.guest_id = guest.id
    interview.save
    podcast.interviews << interview

    visit edit_host_show_interview_path
    expect(page.status_code).to eq(200)
    expect(page).to have_link("Return Home", href: host_path)
    find(:css, "#interview_published").set(true)
    click_button("Update Interview")
    expect(interview.published).to eq(true)
    expect(response).to redirect_to(host_show_interview_path)
  end
end