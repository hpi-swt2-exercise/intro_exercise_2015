require 'rails_helper'
describe "Updating Papers", :type => :feature do
  before(:each) do
    @paper = FactoryGirl.create(:paper)
  end

  it "should update the text and add an additional author on the overview page" do
    new_author = FactoryGirl.create(:author, :first_name => "Hasso", :last_name => "Plattner")
    visit paper_path(@paper)
    click_on("Edit")
    new_year = @paper.year + 10
    fill_in "paper_year", :with => new_year
    last_author_index = @paper.authors.count + 1
    select(new_author.name, :from => "paper_author_id_#{last_author_index}")
    submit_form
    expect(current_path).to eq(paper_path(@paper))
    expect(page).to have_text(new_year)
    expect(page).to have_text(new_author.name)
    expect(page).to have_text(@paper.authors.first.name)
    expect(last_author_index).to eq(@paper.authors.count)
  end

  it "should replace an author" do
    old_author = @paper.authors.first
    new_author = FactoryGirl.create(:author, :first_name => "Hasso", :last_name => "Plattner")
    visit edit_paper_path(@paper)
    select(new_author.name, :from => "paper_author_id_1")
    submit_form()
    expect(page).to have_text(new_author.name)
    expect(page).to_not have_text(old_author.name)
  end

  it "should delete an author" do
    old_author = @paper.authors.first
    visit edit_paper_path(@paper)
    select("(none)", :from => "paper_author_id_1")
    submit_form()
    expect(page).to_not have_text(old_author.name)
  end
end