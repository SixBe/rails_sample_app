module SessionsHelper
	def sign_in(user)
		# This assumes that cookies are application-specific and only 1 is needed
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def signed_in?
    !current_user.nil?
  end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		# First time: call db using the :remember_token cookie
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    # cancel the action of "store_location"
    session.delete(:return_to)
  end

  def store_location
  	session[:return_to] = request.url
  end
end
