class User < ApplicationRecord
  has_many :sessions
  validates :uuid, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end
