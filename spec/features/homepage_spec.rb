require_relative '../rails_helper.rb'

describe 'Landing Page', :type => :feature do

  before do
    Host.destroy_all
    Guest.destroy_all
    Show.destroy_all
    Interview.destroy_all
  end
  
  it 'Welcomes Host to Site' do
    visit '/'
    expect(page.status_code).to eq(200)
    expect(page).to have_content("Welcome to the Podcast Interview Manager")
    expect(page).to have_link("Join us as a Host", href: '/hosts/new')
    expect(page).to have_link("Log in", href: '/login')
  end

end