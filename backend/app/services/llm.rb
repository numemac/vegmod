class Llm

  def self.llm_request(messages, max_tokens)
    response = Hotvox.new.chat(
      parameters: {
        model: "meta-llama-3.1-8b-instruct-abliterated",
        messages: messages,
        temperature: 1.0,
        max_tokens: max_tokens || 100
      }
    )

    return response.dig('choices', 0, 'message', 'content')
  rescue Faraday::ServerError => e
    Rails.logger.error "Error with vision request: #{messages}"
    raise e
  end

end