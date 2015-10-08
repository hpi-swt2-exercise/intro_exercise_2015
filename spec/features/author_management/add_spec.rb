require 'rails_helper'
describe "Adding Authors", :type => :feature do

  it "should add a simple author with correct information" do
    visit authors_path
    click_on("Add author")
    fill_author("Alan", "Turing", "http://wikipedia.org/Alan_Turing")
    submit_form
    expect(current_path).to eq(authors_path)
  end

  it "should not add an author with an invalid name" do
    visit authors_path
    click_on("Add author")
    fill_author("", "", "http://wikipedia.org/Alan_Turing")
    submit_form
    expect(page).to have_text("error")
  end

  it "should not accept wrong URLs as an author's homepage" do
    visit authors_path
    click_on("Add author")
    fill_author("Alan", "Turing", "not_a_url")
    submit_form
    expect(page).to have_text("error")
  end

  def fill_author(first_name, last_name, homepage)
    fill_in "author_first_name", :with => first_name
    fill_in "author_last_name", :with => last_name
    fill_in "author_homepage", :with => homepage
  end
end