class Admin::UsersController < Admin::BaseController
  before_action :set_user, except: [:index]

  # GET /users
  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page]).per(15)
    set_meta_tags({
      title: "管理員管理"
    })
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to admin_users_url, notice: '使用者更新成功'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: '使用者已刪除'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = params[:id] ? User.find(params[:id]) : User.new(user_params)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:admin)
  end
end
