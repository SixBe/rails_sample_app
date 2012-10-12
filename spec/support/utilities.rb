include ApplicationHelper

def valid_signup
	 fill_in "Name",         with: "Example User"
   fill_in "Email",        with: "user@example.com"
   fill_in "Password",     with: "foobar"
   fill_in "Confirmation", with: "foobar"
   return "user@example.com"
end

def sign_in(user)
	visit signin_path
	fill_in "Email",    with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"
	# Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector('div.alert.alert-error', text: message)
	end
end

RSpec::Matchers.define :have_success_message do |message|
	match do |page|
		page.should have_selector('div.alert.alert-success', text: message)
	end
end

RSpec::Matchers.define :have_title do |message|
	match do |page|
		page.should have_selector('title', text: message)
	end
end

RSpec::Matchers.define :have_header do |message|
	match do |page|
		page.should have_selector('h1', text: message)
	end
end

RSpec::Matchers.define :have_list_item do |message|
	match do |page|
		page.should have_selector('li', text: message)
	end
end