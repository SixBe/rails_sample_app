require 'spec_helper'

describe "User pages" do
	subject { page }
  
	describe "profile page" do

    describe "is visible for a signed-in user" do
    	# Code to make a user variable
    	let(:user) { FactoryGirl.create(:user) }
      before do
        # sign_in user 
        visit user_path(user) 
      end
      it { should have_header(user.name) }
      it { should have_title(user.name) }
    end

    # describe "cannot be seen by non signed-in users" do
    #   # Code to make a user variable
    #   let(:user) { FactoryGirl.create(:user) }
    #   before {visit user_path(user)} 
    #   it { should_not have_header(user.name) }
    #   it { should_not have_title(user.name) }
    # end
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
      before { @email = valid_signup() }
      
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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_header("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_success_message('Profile updated') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      # FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      # FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_header('All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_list_item(user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end
 end
