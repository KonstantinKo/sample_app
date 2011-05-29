require 'spec_helper'

describe "Users" do
  
  describe "signup" do
    
    describe "failure" do
    
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do
      
      it "should make a new user" do
        
        lambda do
          visit signup_path
          fill_in "Name",         :with => "John Doe"
          fill_in "Email",        :with => "example@railstutorial.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should render_template('users/show')
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "admin attribute" do
    before(:each) do
      @attr = {:name => "New User", :email => "user@example.com", 
               :password => "foobar", :password_confirmation => "foobar"}
      @user = User.create!(@attr)
    end
    
    it "should respond to admin" do
      @user.should respond_to(:admin)
    end
    
    it "should not be an admin by default" do
      @user.should_not be_admin      
    end
    
    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  

end
