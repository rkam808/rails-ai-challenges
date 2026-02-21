class CreateChatAssistantMessageJob < ApplicationJob
  queue_as :default

  SYSTEM_PROMPT = <<~PROMPT
    You are a Teaching Assistant.\n\nI am a student at the Le Wagon Web Development Bootcamp, learning how to code.\n\nHelp me break down my problem into small, actionable steps, without giving away solutions.\n\nAnswer concisely in Markdown."

    When I am facing a setup issue, check teachers availability and answer with available teachers.

    Answer concisely in markdown.
  PROMPT

  BATCH_NUMBER = 2061

  def perform(user_message)
    @message = user_message
    @chat = user_message.chat
    @challenge = @chat.challenge
    @assistant_message = @chat.messages.create(role: "assistant", content: "")

    if @message.file.attached?
      process_file(@message.file)
    else
      send_question
    end

    @assistant_message.update(content: @response.content)
    broadcast_replace(@assistant_message)

    @chat.generate_title_from_first_message

    if @chat.title_previously_changed?
      Turbo::StreamsChannel.broadcast_update_to(@chat, target: "chat_title", content: @chat.title)
    end
  end

  def broadcast_replace(message)
    Turbo::StreamsChannel.broadcast_replace_to(@chat, target: dom_id(message), partial: "messages/message", locals: { message: message })
  end

  def build_conversation_history
    @chat.messages.each do |message|
      next if message.content.blank?

      @ruby_llm_chat.add_message(message)
    end
  end

  def challenge_context
    "Here is the context of the challenge: #{@challenge.content}."
  end

  def instructions
    [SYSTEM_PROMPT, challenge_context, @challenge.system_prompt].compact.join("\n\n")
  end

  def process_file(file)
    if file.content_type == "application/pdf"
      send_question(model: "gemini-2.0-flash", with: { pdf: @message.file.url })
    elsif file.image?
      send_question(model: "gpt-4o", with: { image: @message.file.url })
    elsif file.audio?
      temp_file = Tempfile.new(["audio", File.extname(@message.file.filename.to_s)])

      URI.open(@message.file.url) do |remote_file|
        IO.copy_stream(remote_file, temp_file)
      end

      send_question(model: "gpt-4o-audio-preview", with: { audio: temp_file.path })
      temp_file.unlink
    end
  end

  def send_question(model: "gpt-4.1-nano", with: {})
    available_teachers_tool = AvailableTeachersTool.new(batch_number: BATCH_NUMBER)

    @ruby_llm_chat = RubyLLM.chat(model: model)
    build_conversation_history
    @ruby_llm_chat.with_tool(available_teachers_tool)
    @ruby_llm_chat.with_instructions(instructions)

    @response = @ruby_llm_chat.ask(@message.content, with: with) do |chunk|
      next if chunk.content.blank? # skip empty chunks

      @assistant_message.content += chunk.content
      broadcast_replace(@assistant_message)
    end
  end
end
