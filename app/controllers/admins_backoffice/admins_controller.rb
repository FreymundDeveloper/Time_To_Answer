class AdminsBackoffice::AdminsController < AdminsBackofficeController
  def index
    @admins = Admin.all
  end

  def edit
    @admin = Admin.find(params[:id])
  end

  def update
    if params[:admin][:password].blank? && params[:admin][:password_confirm].blank?
      params[:admin].extract!(:password, :password_confirm)
    end

    @admin = Admin.find(params[:id])
    params_admin = params.require(:admin).permit(:email, :password, :password_confirm)

    if @admin.update(params_admin)
      redirect_to admins_backoffice_admins_path, notice: "Adminstrador atualizado"
    else
      render :edit
    end
end
