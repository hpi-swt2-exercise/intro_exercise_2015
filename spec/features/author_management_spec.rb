require 'rails_helper'

describe "Author management", :type => :feature do

  it "should add a simple author with correct information" do
    visit "/authors/new"

    fill_in "First Name", :with => "Alan"
    fill_in "Last Name", :with => "Turing"
    fill_in "Homepage", :with => "http://www.wikipedia.org/Alan_Turing"
    click_button "Save"

    expect(current_path).to == authors_path
  end

  it "should not add an author with an invalid name" do
    visit "/authors/new"

    fill_in "First Name", :with => ""
    fill_in "Last Name", :with => ""
    fill_in "Homepage", :with => "http://www.google.com"
    click_button "Save"

    expect(page).to have_text("error")
  end

  it "should not accept wrong URLs as an author's homepage" do
    visit "/authors/new"

    fill_in "First Name", :with => "Alan"
    fill_in "Last Name", :with => "Turing"
    fill_in "Homepage", :with => "i_am_not_a_url"
    click_button "Save"

    expect(page).to have_text("error")
  end
end