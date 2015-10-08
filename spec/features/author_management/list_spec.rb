require 'rails_helper'
describe "Listing Authors", :type => :feature do

  it "should show all authors when navigating from the homepage" do
    FactoryGirl.create(:author)
    visit root_path
    click_on("Show authors")
    expect(current_path).to eq(authors_path)
    expect(page).to have_text("Alan Turing")
  end
end