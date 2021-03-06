require 'rails_helper'

feature 'Create tests' do

  before(:each) do
    User.create(email: "test@email.com", password: "password", password_confirmation: "password")
  end

  context 'User cannot create invalid tests' do

    before(:each) do
      user_sign_in
    end

    scenario 'User cannot submit a test without a valid URL' do
      create_test("myURL", "not_a_url")
      expect(page.body).to have_content("Test url is invalid")
    end

    scenario 'User cannot create two tests with the same name' do
      create_test("Climate", "http://www.climate.com")
      create_test("Climate", "http://www.climate.com")
      expect(page.body).to have_content("Name has already been taken")
    end

    scenario 'User can check multiple questions' do
      visit '/tests/new'
      fill_in 'test_name', with: "BBC Test"
      fill_in 'test_test_url', with: "http://www.bbc.co.uk"
      choose('Product page')
      check 'test_question_ids_1'
      check 'test_question_ids_2'
      question1 = find('#test_question_ids_1')
      question2 = find('#test_question_ids_2')
      question3 = find('#test_question_ids_3')
      expect(question1).to be_checked
      expect(question2).to be_checked
      expect(question3).to_not be_checked
    end

    scenario 'User must choose at least one question' do
      visit '/tests/new'
      fill_in 'test_name', with: 'test'
      fill_in 'test_test_url', with: 'https://www.test.com'
      choose('Product page')
      click_button "create test"
      expect(page.body).to have_content("Question ids can't be blank")
    end

  end

  context 'User can create a test' do

    before do
      user_sign_in
      create_test
    end

    scenario 'Nav bar + button links to add a test' do
      visit '/'
      within '#nav' do
        find(:xpath, "//a[@id='test-new-1']").click
        expect(page).to have_current_path("/tests/new")
      end
    end

    scenario 'User can see a list of all their own tests' do
      visit '/tests'
      expect(page).to have_content "Asos Product Test"
      expect(page).to have_link('View Report', href: "/reports/asos-product-test")
    end
  end

end
