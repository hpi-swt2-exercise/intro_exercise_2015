require 'rails_helper'

describe "Adding Papers", :type => :feature do

  before(:each) do
    @author = FactoryGirl.create(:author)
  end

  it "should add a simple paper" do
    visit("/")
    click_on("Show papers")
    expect(current_path).to eq(papers_path)
    click_on("Add paper")
    fill_paper_details("COMPUTING MACHINERY AND INTELLIGENCE", "Mind 49: 433-460", 1950)
    submit_form()
    expect(current_path).to eq(papers_path)
    expect(page).to have_text("COMPUTING MACHINERY AND INTELLIGENCE")
  end

  it "should not add a paper with an invalid title" do
    visit papers_path
    click_on("Add paper")
    fill_paper_details("", "Mind 49: 433-460", 1950)
    submit_form
    expect(page).to have_text("error")
  end

  it "should not accept a paper with an invalid year" do
    visit papers_path
    click_on("Add paper")
    fill_paper_details("COMPUTING MACHINERY AND INTELLIGENCE", "Mind 49: 433-460", "not a year")
    submit_form
    expect(page).to have_text("error")
  end

  it "should not accept a paper without a venue" do
    visit papers_path
    click_on("Add paper")
    fill_paper_details("COMPUTING MACHINERY AND INTELLIGENCE", "", 1950)
    submit_form
    expect(page).to have_text("error")
  end

  it "should allow to select an author for a paper" do
    visit new_paper_path
    fill_paper_details("COMPUTING MACHINERY AND INTELLIGENCE", "Mind 49: 433-460", 1950)
    5.times{|i| expect(page).to have_text("Author #{i+1}")}
    select(@author.name, :from => 'paper_author_id_1')
    submit_form
    expect(current_path).to eq(papers_path)
    expect(page).to have_text("COMPUTING MACHINERY AND INTELLIGENCE")
  end

  it "should allow to select up to 5 authors for a paper" do

    authors = ["Arian", "Keven", "Ralf", "Thomas", "Matthias"].collect do |name|
      FactoryGirl.create(:author, :first_name => name)
    end

    visit new_paper_path
    fill_paper_details("COMPUTING MACHINERY AND INTELLIGENCE", "Mind 49: 433-460", 1950)
    authors.each_with_index do |author, i|
      select(author.name, :from => "paper_author_id_#{i+1}")
    end
    submit_form

    expect(current_path).to eq(papers_path)
    expect(page).to have_text("COMPUTING MACHINERY AND INTELLIGENCE")
    expect(Paper.last.authors.size).to eq(5)
  end

  it "should ignore if duplicate authors for one paper are selected" do
    visit new_paper_path
    fill_paper_details("COMPUTING MACHINERY AND INTELLIGENCE", "Mind 49: 433-460", 1950)
    select(@author.name, :from => 'paper_author_id_1')
    select(@author.name, :from => 'paper_author_id_2')
    submit_form
    expect(current_path).to eq(papers_path)
    expect(Paper.last.authors.size).to eq(1)
  end

  def fill_paper_details(title, venue, year)
    fill_in "paper_title", :with => title
    fill_in "paper_venue", :with => venue
    fill_in "paper_year", :with => year
  end
end

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