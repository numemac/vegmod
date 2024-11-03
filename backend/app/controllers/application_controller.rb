class ApplicationController < ActionController::Base
  respond_to :json

  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  before_action :set_csrf_cookie
  before_action :authenticate_user!, unless: :session_controller?

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      render :json => {response: 'Forbidden' }, status: 403
    else
      render :json => {response: 'Unable to authenticate' }, status: 401
    end
  end

  private

  def session_controller?
    controller_name == 'session'
  end

  def schemas(json)
    klasses = traverse(json, :_type).uniq
    klasses.map { |k| k.constantize }.map { |klass|
      [ 
        klass.name,
        {
          # associations: klass.reflect_on_all_associations.map { |a| [a.name, a.macro] }.to_h,
          # columns: klass.columns.map { |c| [c.name, c.type] }.to_h,
          attributes: [
            *klass.column_names.map { |c| [c, klass.columns_hash[c].type] },
            *klass.computed_fields.map { |c| [c, :computed] }
          ].to_h,
          associations: klass.reflect_on_all_associations.map { |a| [a.name, a.macro] }.to_h
        }
      ]
    }.to_h
  end

  # returns all values of the key "_type" in the json
  def traverse(json, key)
    types = []
    if json.is_a?(Array)
      json.each do |item|
        types += traverse(item, key)
      end
    elsif json.is_a?(Hash)
      json.each do |k, v|
        if k.to_s == key.to_s
          types << v
        else
          types += traverse(v, key)
        end
      end
    end
    
    return types
  end

  def set_csrf_cookie
    cookies['CSRF-TOKEN'] = form_authenticity_token
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up)
  end

end
