Given(/^I am on the homepage$/) do
  visit('/')
end

When(/^I enter "(.*?)"$/) do |input|
  fill_in('name', with: input)
end

When(/^I press "(.*?)"$/) do |button|
  click_button('submit')
end

When(/^I click "(.*?)"$/) do |link|
  click_link(link)
end

Then(/^I should see "(.*?)"$/) do |displayed|
  expect(page).to have_content(displayed)
end

Given(/^the computer has chosen "(.*?)"$/) do |weapon|
  #Capybara.app::Game.computer_picks(weapon)
end