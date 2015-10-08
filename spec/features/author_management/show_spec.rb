require 'rails_helper'
describe "Show Authors", :type => :feature do

  before(:each) do
    @paper = FactoryGirl.create(:paper)
    @author = @paper.authors.first
  end

  it "should show an author's details" do
    visit root_path
    click_on("Show authors")
    click_on(@author.name)
    expect(current_path).to eq(author_path(@author))
    expect(page).to have_text(@paper.title)
  end

  it "should contain links to the author's papers on their detail page" do
    visit author_path(@author)
    click_on(@paper.title)
    expect(current_path).to eq(paper_path(@paper))
  end
end