class Vision

  def self.vision_request(messages, max_tokens)
    response = Hotvox.new.chat(
      parameters: {
        model: "moondream2",
        messages: messages,
        temperature: 0.4,
        max_tokens: max_tokens || 100
      }
    )

    return response.dig('choices', 0, 'message', 'content')
  rescue Faraday::ServerError => e
    Rails.logger.error "Error with vision request: #{messages}"
    raise e
  end

  def self.describe(image_url)
    messages = [
      {
        role: "user",
        content: [
          { type: "text", text: "Describe what you see in the image below." },
          { type: "image_url", image_url: { url: image_url } }
        ] 
      }
    ]

    return vision_request(messages, 100)
  end

end