# Abstract controller class that provides common behavior for all
# non-read-only controllers.
#
# Provides useful methods for creating, updating, and deleting
# records in the database.
#
class CudController < ApplicationController

  before_action do
    require_user
 
    # Set the record if an id is provided on a non-create action
    if action_name != 'create' && params[:id]
      @record = model_class.find(params[:id])
    end

    authorize_update  if action_name == 'update'
    authorize_destroy if action_name == 'destroy'
  end

  def require_params(required_params)
    missing_params = required_params.select { |param| params[param].nil? }

    if missing_params.any?
      render json: { error: "Missing required parameters: #{missing_params.join(', ')}" }, status: :bad_request
      return false
    end

    return true
  end

  def require_param(required_param)
    return require_params([required_param])
  end

  def model_class
    raise NotImplementedError
  end

  private

  # if the user is not present, return an error response
  def require_user
    unless current_user
      render json: { 
        error: 'You must be signed in to perform this action'
      }, status: :unauthorized
    end
  end

  # authorize the user can update the record
  def authorize_update
    authorize! :update, @record
  end

  # authorize the user can destroy the record
  def authorize_destroy
    authorize! :destroy, @record
  end

end