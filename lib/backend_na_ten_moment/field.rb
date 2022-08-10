# frozen_string_literal: true

require 'observer'
# require 'json'
require_relative 'position'

class Field
  include Observable
  attr_accessor :status, :terrain, :obstacle, :occupant, :display, :offset
  attr_reader :position

  def initialize(x: 0, y: 0, status: 'empty', occupant: '', terrain: '', obstacle: false, display: '',offset: '')
    @position = Position.new(x, y)
    @offset = offset
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

  def make_json
    temp_occupant = ''
    temp_occupant = @occupant.make_json unless @occupant.empty?
    field_json = {
      position: @position.make_json,
      status: @status,
      occupant: temp_occupant,
      terrain: @terrain,
      obstacle: @obstacle
    }
    JSON.generate(field_json)
  end

  def is_occupied?
    @occupant != ''
  end

  def is_empty?
    @occupant == ''
  end
end
