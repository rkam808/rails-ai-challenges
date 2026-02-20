RubyLLM.configure do |config|
  config.openai_api_key = ENV["OPENAI_API_KEY"]
  # NOTE(Eschults): Uncomment next two lines to use the Github Azure OpenAI playground
  # config.openai_api_key = ENV["GITHUB_TOKEN"]
  # config.openai_api_base = "https://models.inference.ai.azure.com"
  # Add keys ONLY for providers you intend to use
  # config.anthropic_api_key = ENV.fetch('ANTHROPIC_API_KEY', nil)
  # ... see Configuration guide for all options ...
end
