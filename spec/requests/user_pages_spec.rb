require 'spec_helper'

describe "User pages" do
	subject { page }
  
	describe "profile page" do
  	# Code to make a user variable
  	let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
  	it { should have_header(user.name) }
  	it { should have_title(user.name) }
  end

  
	describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }
        it { should have_title('Sign Up') }
        it { should have_content('error') }
        it { should have_error_message('error') }
        it { should have_list_item('Name can\'t be blank') }
        it { should have_list_item('Email can\'t be blank') }
        it { should have_list_item('Password can\'t be blank') }
        it { should have_list_item('Email is invalid') }
      end
    end

    describe "with valid information" do
      before do
       @email = valid_signup()
      end
      # let(:email_signup) { page.find_field(:email).value }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after submission" do
        before { click_button submit }
        let (:signed_user) { User.find_by_email(@email) }
        it { should have_selector('title', text: signed_user.name) }
        it { should have_success_message('Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end


 end
