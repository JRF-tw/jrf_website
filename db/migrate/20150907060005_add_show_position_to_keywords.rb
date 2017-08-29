class AddShowPositionToKeywords < ActiveRecord::Migration[4.2]
  def change
    add_column :keywords, :show_position, :integer, null: false, default: 0
  end
end
