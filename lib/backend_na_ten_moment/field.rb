# frozen_string_literal: true

require 'observer'
# require 'json'
require_relative 'position'

# individual game field, observable
class Field
  include Observable
  attr_accessor :status, :terrain, :obstacle, :occupant, :display, :offset
  attr_reader :position

  # rubocop:disable all
  def initialize(x: 0, y: 0, status: 'empty', occupant: '', terrain: '', obstacle: false, offset: '', field_json: '')
  # rubocop: enable all
    @field_json = field_json
    if @field_json != ''
      from_json
    else
      @position = Position.new(x, y)
      @offset = offset
      @status = status
      @terrain = terrain
      @obstacle = obstacle
    end
    @occupant = occupant
  end

  def update_occupant(new_occupant)
    @occupant = new_occupant
    changed
    notify_observers(@position, occupied?)
  end

  def make_json
    field_json = {
      position: @position.make_json,
      status: @status,
      terrain: @terrain,
      obstacle: @obstacle,
      offset: @offset
    }
    JSON.generate(field_json)
  end

  def from_json
    hash_of_field = JSON.parse(@field_json)
    @position = Position.new(position_json: hash_of_field['position'])
    assign_instance_variables_from_hash(hash_of_field)
  end

  def occupied?
    @occupant != ''
  end

  def empty?
    @occupant == ''
  end

  private

  def assign_instance_variables_from_hash(hash_of_field)
    @offset = hash_of_field['offset']
    @status = hash_of_field['status']
    # @occupant = if hash_of_field['occupant'] != ''
    #               Minion.new(minion_json: hash_of_field['occupant'])
    #             else
    #               ''
    #             end
    @terrain = hash_of_field['terrain']
    @obstacle = hash_of_field['obstacle']
    @offset = hash_of_field['offset']
  end

  def set_occupant
    if occupied?
      @occupant.make_json
    else
      ''
    end
  end
end
