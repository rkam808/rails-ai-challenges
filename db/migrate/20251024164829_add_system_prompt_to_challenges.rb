class AddSystemPromptToChallenges < ActiveRecord::Migration[7.1]
  def change
    add_column :challenges, :system_prompt, :text
  end
end
