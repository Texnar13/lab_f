class User < ApplicationRecord
  validates :mail, :uniqueness => true
  has_many :notes, dependent: :destroy

end
