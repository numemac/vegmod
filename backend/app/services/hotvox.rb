require 'openai'

class Hotvox < OpenAI::Client
  def initialize
    super(
      access_token: "hotvox-api-key",
      uri_base: "https://openai.augustynowicz.ca/v1",
      log_errors: true
    )
  end
end