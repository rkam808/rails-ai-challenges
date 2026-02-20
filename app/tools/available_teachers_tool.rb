require 'open-uri'

class AvailableTeachersTool < RubyLLM::Tool
  description "Gets available teachers for a batch."

  def initialize(batch_number:)
    @batch_number = batch_number
  end

  def execute
    url = "https://kitt.lewagon.com/api/v1/camps/#{@batch_number}/todays_teachers"

    response = URI.parse(url).read
    JSON.parse(response)
  rescue => e
    { error: e.message }
  end
end
