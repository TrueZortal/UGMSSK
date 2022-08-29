class Session < ApplicationRecord
  belongs_to :user, foreign_key: 'id'
end