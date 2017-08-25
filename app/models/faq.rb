class Faq < ApplicationRecord
  belongs_to :keyword
  validates_presence_of :question, :answer, :keyword_id
  default_scope { order(position: :asc) }
end
