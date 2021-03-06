require 'rails_helper'

feature 'Report page' do

  before(:each) do
    user_sign_up
    Test.create(name: 'BBC', test_url: "https://www.bbc.co.uk/news", test_type_id: 1, slug: "bbcnews", question_ids: [1,4,7], user_id: 1)
    Answer.create(format: "range", response: 5, question_id: 1, test_id: Test.last.id, comment: "wow")
    Answer.create(format: "range", response: 2, question_id: 4, test_id: Test.last.id, comment: "don't like that")
    Answer.create(format: "range", response: 4, question_id: 7, test_id: Test.last.id, comment: "looks great")
  end

  scenario 'report page has right test info', js: true do
    user_sign_in
    visit '/reports/bbcnews'
    expect(page).to have_content("BBC // Test Report")
    within '#summary' do
      expect(page).to have_content("Test URL: https://www.bbc.co.uk/news")
      expect(page).to have_content("Number of questions: 3")
      expect(page).to have_content("Number of respondents: 1")
      expect(page).to have_content("Percentage completion: 100%")
    end
    within '#report-chart' do
      expect(page.body).to have_content("How easy is it to compare this product against other options?")
    end
    within '#question1-comments' do
      expect(page).to have_content('wow')
    end
  end

  scenario 'average chart does not display if no reponses' do
    user_sign_in
    create_test("Makers", "http://www.makersacademy.com/")
    visit '/reports/makers'
    within '#report-chart' do
      expect(page.body).to have_content("Sorry, no data yet!")
    end
  end

  scenario 'User can only view reports page when signed in' do
    visit '/reports/1'
    expect(page).to have_current_path('/users/sign_in')
  end

  scenario 'Nav bar chart icon links to tests#index' do
    user_sign_in
    visit '/'
    within '#nav' do
      find(:xpath, "//a[@id='tests-all-1']").click
      expect(page).to have_current_path("/tests")
    end
  end

  scenario 'reports index redirects to test index' do
    user_sign_in
    visit '/reports'
    expect(page).to have_current_path('/tests')
  end

end
