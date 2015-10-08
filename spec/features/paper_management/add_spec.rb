require 'rails_helper'
describe "Adding Papers", :type => :feature do

  before(:each) do
    @author = FactoryGirl.create(:author)
  end

  it "should add a simple paper" do
    visit root_path
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