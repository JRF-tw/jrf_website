class AddPositionToFaq < ActiveRecord::Migration[4.2]
  def change
    add_column :faqs, :position, :integer, null: false, default: 0
  end
end
