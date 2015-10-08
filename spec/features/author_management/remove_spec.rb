require 'rails_helper'
describe "Removing Authors", :type => :feature do

  it "should remove an author" do
    alan = FactoryGirl.create(:author)
    hasso = FactoryGirl.create(:author, :first_name => "Hasso", :last_name => "Plattner")
    visit authors_path
    click_remove(hasso)
    expect(current_path).to eq(authors_path)
    expect(page).not_to have_text("Hasso Plattner")
    expect(page).to have_text("Alan Turing")
  end

  it "should not remove an author's papers when deleting the author" do
    paper = FactoryGirl.create(:paper)
    visit authors_path
    click_remove(paper.authors.first)
    visit papers_path
    expect(page).to have_text(paper.title)
  end

  it "should remove a deleted author from the respective list in the papers overview" do
    paper = FactoryGirl.create(:paper)
    alan = paper.authors.first
    visit paper_path(paper)
    expect(page).to have_text(alan.first_name + " " + alan.last_name)
    visit authors_path
    click_remove(alan)
    expect(page).not_to have_text(alan.first_name + " " + alan.last_name)
  end

  def click_remove(author)
    find("a[href='#{author_path(author)}'][data-method='delete']").click()
  end
end