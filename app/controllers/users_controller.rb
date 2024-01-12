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
    @user = User.new user_params

    check = (verify_recaptcha action: 'create_user', minimum_score: 0.7, secret_key: ENV['RECAPTCHA_SECRET_V3']) ||
    (verify_recaptcha model: @user, secret_key: ENV['RECAPTCHA_SECRET_KEY'])

    if check && @user.save
      render turbo_stream: turbo_stream.replace('steps_frame', partial: 'users/success_frame')
    else
      @user.validate
      @user.errors.add(:base, t('recaptcha.errors.verification_failed')) unless check 
      render :new
    end
  end

    # def create
    #   @user = User.new(user_params)
  
    #   case params[:step]
    #   when '1'
    #     render turbo_stream: turbo_stream.replace('step_frame', partial: 'users/step_2')
    #   when '2'
    #     render turbo_stream: turbo_stream.replace('step_frame', partial: 'users/step_3')
    #   when '3'
    #     # Implement recaptcha verification logic here
    #     if verify_recaptcha(model: @user, secret_key: ENV['RECAPTCHA_SECRET_KEY'])
    #       # Do any additional processing, e.g., save the user
    #       render turbo_stream: turbo_stream.replace('step_frame', partial: 'users/done')
    #     else
    #       @user.errors.add(:base, t('recaptcha.errors.verification_failed'))
    #       render turbo_stream: turbo_stream.replace('step_frame', partial: 'users/step_3')
    #     end
    #   else
    #     # Handle other cases or fallback
    #     render turbo_stream: turbo_stream.replace('step_frame', partial: 'users/step_1')
    #   end
    # end
  

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
      params.require(:user).permit(:first_name, :last_name)
    end
end
