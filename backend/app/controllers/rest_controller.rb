class RestController < ApplicationController

  def index
    model = model_class.all
    render json: model, minimal: true
  end

  def show
    model = model_class.find(params[:id])
    options = {}
    if params[:association]
      association = model.has_many_associations.find { |a| a[:name].to_sym == params[:association].to_sym }
      options[:association] = association[:name] if association
    end
    render json: model, **options
  end

  private

  def model_class
    controller_name.classify.constantize
  end

end