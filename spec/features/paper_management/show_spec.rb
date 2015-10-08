require 'rails_helper'
describe "Showing Papers", :type => :feature do

  before(:each) do
    @paper = FactoryGirl.create(:paper)
  end

  it "should show a paper overview and have a link to the paper details" do
    visit root_path
    click_on("Show papers")
    expect(current_path).to eq(papers_path)
    expect(page).to have_text(@paper.title)
    click_on(@paper.title)
    expect(current_path).to eq(paper_path(@paper))
  end

  it "should provide a nice detail view" do
    visit(paper_path(@paper))
    @paper.authors.each do |author|
      expect(page).to have_text(author.name)
    end
    expect(page).to have_text(@paper.title)
    expect(page).to have_text(@paper.venue)
    expect(page).to have_text(@paper.year)
  end

  it "should properly link to the author's detail page" do
    visit(paper_path(@paper))
    click_on(@paper.authors.first.name)
    expect(current_path).to eq(author_path(@paper.authors.first))
  end
end