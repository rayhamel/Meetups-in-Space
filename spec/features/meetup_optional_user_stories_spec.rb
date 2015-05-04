require 'spec_helper'

feature 'optional user stories' do
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

  # As a user
  # I want to leave a meetup
  # So that I'm no longer listed as a member of the meetup
  # Acceptance Criteria:
  #
  # * I must be authenticated.
  # * I must have already joined the meetup.
  # * I see a message that lets me know I left the meetup successfully.

  scenario 'user wants to successfully leaves meetup' do
    visit '/meetups'
    rand_num = rand(1_000_000).to_s
    user = User.create(provider: 'github', uid: rand_num, username: rand_num, email: 'email@email.com', avatar_url: rand_num)
    login_as(user)

    click_link('Boston Ruby Meetup')
    click_button('Join this meetup')
    click_button('Leave this meetup')

    expect(page).to have_content('Successfully left!')
    expect(page).to have_no_css("img[src$='#{rand_num}']")
  end

  scenario 'user unsuccessfully leaves meetup because not signed in' do
    visit '/meetups'

    click_link('Boston Ruby Meetup')
    click_button('Join this meetup')
    expect(page).to have_content('Error: not successfully joined')
    expect(page).to have_no_content('Leave this meetup')
  end

  scenario 'user unsuccessfully leaves meetup because not a member' do
    visit '/meetups'
    rand_num = rand(1_000_000).to_s
    user = User.create(provider: 'github', uid: rand_num, username: rand_num, email: 'email@email.com', avatar_url: rand_num)
    login_as(user)

    click_link('Boston Ruby Meetup')

    expect(page).to have_no_content('Leave this meetup')
  end

  # As a user
  # I want to leave comments on a meetup
  # So that I can communicate with other members of the group
  #
  # Acceptance Criteria:
  #
  # * I must be authenticated.
  # * I must have already joined the meetup.
  # * I can optionally provide a title for my comment.
  # * I must provide the body of my comment.
  # * I should see my comment listed on the meetup show page.
  # * Comments should be listed most recent first.

  scenario 'user successfully posts a comment' do
    visit '/meetups'
    rand_num = rand(1_000_000).to_s
    user = User.create(provider: 'github', uid: rand_num, username: rand_num, email: 'email@email.com', avatar_url: rand_num)
    login_as(user)

    click_link('Boston Ruby Meetup')
    click_button('Join this meetup')

    fill_in 'title', with: 'comment title'
    fill_in 'text', with: 'text for comment'
    click_button 'New Comment'

    expect(page).to have_content('comment title')
    expect(page).to have_content('text for comment')
    expect(page).to have_selector('#comments_section p:first-child strong', text: rand_num)
  end

  scenario 'user successfully posts a comment without title' do
    visit '/meetups'
    rand_num = rand(1_000_000).to_s
    user = User.create(provider: 'github', uid: rand_num, username: rand_num, email: 'email@email.com', avatar_url: rand_num)
    login_as(user)

    click_link('Boston Ruby Meetup')
    click_button('Join this meetup')

    fill_in 'text', with: 'text for comment with no title'
    click_button 'New Comment'

    expect(page).to have_content('text for comment with no title')
  end

  scenario "user can't comment without joining group" do
    visit '/meetups'
    rand_num = rand(1_000_000).to_s
    user = User.create(provider: 'github', uid: rand_num, username: rand_num, email: 'email@email.com', avatar_url: rand_num)
    login_as(user)

    click_link('Boston Ruby Meetup')
    expect(page).to have_no_selector('#submit_comment')
  end

  scenario "user can't comment signing in" do
    visit '/meetups'

    click_link('Boston Ruby Meetup')
    expect(page).to have_no_selector('#submit_comment')
  end

  scenario 'unsuccessfully post a comment without a body' do
    visit '/meetups'
    rand_num = rand(1_000_000).to_s
    user = User.create(provider: 'github', uid: rand_num, username: rand_num, email: 'email@email.com', avatar_url: rand_num)
    login_as(user)

    click_link('Boston Ruby Meetup')
    click_button('Join this meetup')

    fill_in 'title', with: 'comment title w/ no body'
    click_button 'New Comment'

    expect(page).to have_no_content('comment title w/ no body')
  end
end
