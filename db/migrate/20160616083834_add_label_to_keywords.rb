class AddLabelToKeywords < ActiveRecord::Migration[4.2]
  def change
    add_column :keywords, :label, :string
    add_column :keywords, :label_type, :string
  end
end
