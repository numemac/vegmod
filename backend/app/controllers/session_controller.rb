class SessionController < ApplicationController
  
  def index
    json = {
      user: current_user.as_json,
      plugins: Plugin.all.as_json,
    }

    render json: json.merge(schemas: schemas(json))
  end

end