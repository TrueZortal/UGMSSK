# frozen_string_literal: true

require 'observer'
# require 'json'
require_relative 'position'

class Field
  include Observable
  attr_accessor :status, :terrain, :obstacle, :occupant, :display, :offset
  attr_reader :position

  def initialize(x: 0, y: 0, status: 'empty', occupant: '', terrain: '', obstacle: false, display: '', offset: '', field_json: '')
    @field_json = field_json
    if @field_json != ''
      from_json
    else
      @position = Position.new(x, y)
      @offset = offset
      @status = status
      @occupant = occupant
      @terrain = terrain
      @obstacle = obstacle
    end
  end

  def update_occupant(new_occupant)
    @occupant = new_occupant
    changed
    notify_observers(@position, is_occupied?)
  end

  def make_json
    temp_occupant = if is_occupied?
                      @occupant.make_json
                    else
                      ''
                    end
    field_json = {
      position: @position.make_json,
      status: @status,
      occupant: temp_occupant,
      terrain: @terrain,
      obstacle: @obstacle,
      offset: @offset
    }
    JSON.generate(field_json)
  end

  def from_json
    hash_of_field = JSON.parse(@field_json)
    @position = Position.new(position_json: hash_of_field['position'])
    @offset = hash_of_field['offset']
    @status = hash_of_field['status']
    @occupant = if hash_of_field['occupant'] != ''
                  Minion.new(minion_json: hash_of_field['occupant'])
                else
                  ''
                end
    @terrain = hash_of_field['terrain']
    @obstacle = hash_of_field['obstacle']
    @offset = hash_of_field['offset']
  end

  def is_occupied?
    @occupant != ''
  end

  def is_empty?
    @occupant == ''
  end
end
