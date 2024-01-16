class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    user_attributes = session[:user_attributes] || {}
    @user = User.new(user_attributes.merge(user_params))

    check = (verify_recaptcha action: 'create_user', minimum_score: 0.7, secret_key: ENV['RECAPTCHA_SECRET_V3']) ||
    (verify_recaptcha model: @user, secret_key: ENV['RECAPTCHA_SECRET_KEY'])
    
    if check && @user.save
      #render success
    else
      @user.validate
      @user.errors.add(:base, t('recaptcha.errors.verification_failed')) unless check 
      render turbo_stream: turbo_stream.update('content', partial: 'mobile_step_form')
    end
  end
  
  def go_to_mobile_step
    @user = User.new user_params
    session[:user_attributes] = @user.attributes
    # render turbo_stream: turbo_stream.update('steps_frame', partial: 'mobile_step_form')
  end
  

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :phone_number)
    end
end
