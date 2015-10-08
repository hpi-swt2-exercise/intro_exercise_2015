require 'rails_helper'
describe "Removing Papers", :type => :feature do
  before(:each) do
    @paper = FactoryGirl.create(:paper)
  end

  it "should delete a paper if I follow the corresponding link" do
    visit papers_path
    click_remove(@paper)
    expect(current_path).to eq(papers_path)
    expect(page).to_not have_text(@paper.title)
  end

  it "should not remove the authors if I remove a paper" do
    visit papers_path
    click_remove(@paper)
    visit authors_path
    @paper.authors.each{|author| expect(page).to have_text(author.name)}
  end

  it "should not show an deleted paper on the author's overview page" do
    visit papers_path
    click_remove(@paper)
    @paper.authors.each do |author|
      visit author_path(author)
      expect(page).to_not have_text(@paper.title)
    end
  end

  def click_remove(paper)
    find("a[href='#{paper_path(paper)}'][data-method='delete']").click()
  end
end