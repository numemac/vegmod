class SubredditPluginsController < CudController

  def model_class
    Reddit::SubredditPlugin
  end

  def create
    require_params [:subreddit_id, :plugin_id]

    @subreddit =  Reddit::Subreddit.find(params[:subreddit_id])
    @plugin =     Plugin.find(params[:plugin_id])

    authorize! :update, @subreddit

    Reddit::SubredditPlugin.create!(
      subreddit: @subreddit,
      plugin: @plugin,
      enabled: true,
      config: @plugin.default_config,
    )
  end

  def destroy
    require_param :id

    @record.destroy
  end

end