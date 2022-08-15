# frozen_string_literal: true

class BoardState < ApplicationRecord
  validates :board, presence: true
end
