class RemoveModelIdFromChats < ActiveRecord::Migration[7.1]
  def change
    remove_column :chats, :model_id, :string
  end
end
