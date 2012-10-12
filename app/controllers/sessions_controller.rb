class SessionsController < ApplicationController
	def new
		
	end

	def create
		user = User.find_by_email(params[:email].downcase)

		if user && user.authenticate(params[:password])
			# Signin succeeded: re-direct to the user's show page
			flash[:success] = "Welcome"
			sign_in user
  		redirect_back_or user
		else
			# Create an error message and re-render the signin form
			flash.now[:error] = "Invalid name/password combination" # gets persisted for one request and a re-render is not a new request
			# as a result the flash will persist if we change page after trying to signin with incorrect information
  		render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
