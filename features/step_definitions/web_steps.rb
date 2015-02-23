require 'rspec/mocks'

# World(RSpec::Mocks::ExampleMethods)
# Before do
#   RSpec::Mocks.setup
# end

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
  # allow_any_instance_of(Computer).to receive(:choose_weapon).and_return(:rock)
  click_link(link)
end

Then(/^I should see "(.*?)"$/) do |displayed|
  # allow_any_instance_of(Computer).to receive(:choose_weapon).and_return(:rock)
  expect(page).to have_content(displayed)
end

Given(/^the computer has chosen "(.*?)"$/) do |weapon|  
  # Computer.any_instance.stub(:choose_weapon).and_return(:Rock)
end