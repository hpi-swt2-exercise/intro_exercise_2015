require 'rails_helper'
describe "Update Authors", :type => :feature do

  it "should update an author and propagate the changes throughout the page" do
    paper = FactoryGirl.create(:paper)
    author = paper.authors.first
    visit author_path(author)
    click_on("Edit")
    fill_in "author_first_name", :with => "Hasso"
    submit_form
    expect(current_path).to eq(authors_path)
    expect(page).to have_text("Hasso #{author.last_name}")
    visit paper_path(paper)
    expect(page).to have_text("Hasso #{author.last_name}")
  end
end