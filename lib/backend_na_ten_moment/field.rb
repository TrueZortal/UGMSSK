# frozen_string_literal: true

require 'observer'
require_relative 'position'

class Field
  include Observable
  attr_accessor :status, :terrain, :obstacle, :occupant
  attr_reader :position

  def initialize(x: 0, y: 0, status: 'empty', occupant: '', terrain: '', obstacle: false)
    @position = Position.new(x, y)
    @status = status
    @occupant = occupant
    @terrain = terrain
    @obstacle = obstacle
  end

  def update_occupant(new_occupant)
    @occupant = new_occupant
    changed
    notify_observers(@position, is_occupied?)
  end

  def is_occupied?
    @occupant != ''
  end

  def is_empty?
    @occupant == ''
  end
end
