require 'spec_helper'

feature 'user checks for joined members in meetup' do
  # As a user
  # I want to see who has already joined a meetup
  # So that I can see if any of my friends have joined
  #
  # * On the details page for a meetup, I should see a list of the members that have already joined.
  # * I should see each member's avatar.
  # * I should see each member's username.

  scenario 'meetup has info of people who have joined' do
    visit '/meetups'

    click_link('Boston Ruby Meetup')
    expect(page).to have_content('Boston Ruby Meetup')
    expect(page).to have_content('Boston, MA')
    expect(page).to have_content('Talk about Ruby')
    expect(page).to have_content('davidrf')
    expect(page).to have_css("img[src$='https://avatars.githubusercontent.com/u/9678182?v=3']")
  end
end
