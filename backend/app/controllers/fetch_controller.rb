class FetchController < ApplicationController
  
  def index
    if params[:id].empty?
      raise "Invalid id: #{id}"
    end

    type = params[:type].constantize
    if !type.is_a?(Class)
      raise "Invalid type"
    end

    # limit param can be nil or a number
    if params[:limit] && params[:limit].to_i.to_s != params[:limit]
      raise "Invalid limit, must be a number or null"
    end

    # offset param can be nil or a number
    if params[:offset] && params[:offset].to_i.to_s != params[:offset]
      raise "Invalid offset, must be a number or null"
    end

    record = type.find_by!(type.fetch_column => params[:id])

    authorize! :read, record
    record[:_authorized] = true

    json = record.as_json(
      # columns: params[:columns] == "true",
      # computed_fields: params[:computed_fields] == "true",
      attributes: params[:attributes] == "true",
      associations: params[:associations],
      ability: current_ability,
      offset: params[:offset],
      limit: params[:limit],
    )
  
    render json: json.merge(schemas: schemas(json))
  end

end