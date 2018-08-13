class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i(show edit update destroy)

  def index
    @q = User.ransack(params[:q])
    @q.sorts = 'id asc' if @q.sorts.empty?
    @users = @q.result.page(params[:page])
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_path(@user),
        notice: t('admin.messages.create.success')
    else
      flash.now[:alert] = t('admin.messages.create.failure')
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user),
        notice: t('admin.messages.update.success')
    else
      flash.now[:alert] = t('admin.messages.update.failure')
      render :edit
    end
  end

  def destroy
    @user.destroy!
    redirect_to admin_users_path,
      notice: t('admin.messages.destroy.success')
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :id,
      :email,
      :last_name,
      :first_name,
      :password,
      :password_confirmation,
    )
  end
end
