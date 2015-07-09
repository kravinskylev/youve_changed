require 'test_helper'

class UserCanSendEmailTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  def setup
    Capybara.app = YouveChanged::Application
    reset_session!
  end

  def test_loads_homepage
    visit '/'
    assert page.has_content? "Welcome"
  end

  def test_logged_in_user_sees_email_form
    user = User.create name: "Horace",
                       email: "horace@turing.io",
                       password: "password"

    visit '/'
    click_on 'Login'

    fill_in "email", with: user.email
    fill_in "password", with: user.password
    click_on "Submit"

    assert_equal '/', current_path
    assert page.has_content? "Horace"
    assert page.has_css? "form#email-form"

    assert ActionMailer::Base.deliveries.empty?

    fill_in "email", with: "brett@happybday.com"
    click_on "Submit"

    mail = ActionMailer::Base.deliveries.last

    assert_equal 1, ActionMailer::Base.deliveries.count
    assert_equal "", mail.body.raw_source
  end
end
