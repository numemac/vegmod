class UsersController < CudController

  def model_class
    User
  end

  def update
    require_param :id

    @record.update!(user_params)
  end

  private

  def user_params
    params.permit(:dark_mode)
  end

end