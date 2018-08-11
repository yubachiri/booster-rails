class Admin::AdminUsersController < Admin::BaseController
  before_action :set_admin_user, only: %i(show edit update destroy)

  def index
    @q = AdminUser.ransack(params[:q])
    @q.sorts = 'id asc' if @q.sorts.empty?
    @admin_users = @q.result.page(params[:page])
  end

  def show
  end

  def new
    @admin_user = AdminUser.new
  end

  def create
    @admin_user = AdminUser.new(admin_user_params)
    if @admin_user.save
      redirect_to admin_admin_user_path(@admin_user),
      notice: t('admin.messages.create.success')
    else
      flash.now[:alert] = t('admin.messages.create.failure')
      render :new
    end
  end

  def edit
  end

  def update
    if @admin_user.update(admin_user_params)
      redirect_to admin_admin_user_path(@admin_user),
        notice: t('admin.messages.update.success')
    else
      flash.now[:alert] = t('admin.messages.update.failure')
      render :edit
    end
  end

  def destroy
    @admin_user.destroy!
    redirect_to admin_admin_users_path,
      notice: t('admin.messages.destroy.success')
  end

  def password
  end

  def password_update
    if current_admin_user.update(admin_user_params)
      bypass_sign_in(current_admin_user)
      redirect_to admin_admin_user_path(current_admin_user),
        notice: t('admin.messages.update.success')
    else
      flash.now[:alert] = t('admin.messages.update.failure')
      render :password
    end
  end

  private

  def set_admin_user
    @admin_user = AdminUser.find(params[:id])
  end

  def admin_user_params
    params.require(:admin_user).permit(
      :id,
      :name,
      :email,
      :password,
      :password_confirmation,
    )
  end
end
