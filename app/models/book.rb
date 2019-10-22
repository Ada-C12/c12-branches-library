class Book < ApplicationRecord
  belongs_to :author
  has_and_belongs_to_many :genres

  validates :title, presence: true

  def self.all_in_alpha_order
    return Book.all.order(title: :asc)
  end
end
