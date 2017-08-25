class CreateFaqs < ActiveRecord::Migration[4.2]
  def change
    create_table :faqs do |t|
      t.references :keyword, index: true
      t.string :question
      t.text :answer
    end
  end
end
