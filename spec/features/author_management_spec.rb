require 'rails_helper'

describe "Adding Authors", :type => :feature do

  it "should add a simple author with correct information" do
    visit "/authors/new"
    fill_author("Alan", "Turing", "http://wikipedia.org/Alan_Turing")
    submit_form
    expect(current_path).to eq(authors_path)
  end

  it "should not add an author with an invalid name" do
    visit "/authors/new"
    fill_author("", "", "http://wikipedia.org/Alan_Turing")
    submit_form
    expect(page).to have_text("error")
  end

  it "should not accept wrong URLs as an author's homepage" do
    visit "/authors/new"
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

describe "Listing Authors", :type => :feature do

  it "should show all authors when navigating from the homepage" do
    FactoryGirl.create(:author)
    visit "/"
    click_on("Show authors")
    expect(current_path).to eq(authors_path)
    expect(page).to have_text("Alan Turing")
  end
end

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

describe "Show Authors", :type => :feature do

  before(:each) do
    @paper = FactoryGirl.create(:paper)
    @author = @paper.authors.first
  end

  it "should show an author's details" do
    visit "/"
    click_on("Show authors")
    click_on("#{@author.first_name} #{@author.last_name}")
    expect(current_path).to eq(author_path(@author))
    expect(page).to have_text(@paper.title)
  end

  it "should contain links to the author's papers on their detail page" do
    visit author_path(@author)
    click_on(@paper.title)
    expect(current_path).to eq(paper_path(@paper))
  end
end

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