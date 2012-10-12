class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  # set per_page globally
  # WillPaginate.per_page = 10

  def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    name = @user.name
    @user.destroy
    flash[:success] = "User #{name} destroyed."
    redirect_to users_url
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save	
  		# handle a successfull save
      sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    # The correct_user has already defined @user
  end

  def update
    # The correct_user has already defined @user
    if @user.update_attributes(params[:user])
      # Handle successful edit
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    def signed_in_user
      # redirect_to signin_url, notice: "Please sign in." unless signed_in?
      unless signed_in?
        store_location
        flash[:notice] = "Please sign in."
        redirect_to signin_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      @user = User.find(params[:id])
      if current_user.admin? && current_user?(@user)
        flash[:notice] = "You cannot delete yourself"
      else 
        redirect_to(root_path) unless current_user.admin?
      end
    end
end
