# frozen_string_literal: true

class ManaPool
  attr_accessor :mana, :max, :current

  def initialize(mana: 0)
    @max = mana == String ? mana.to_i : mana
    @mana = @max
    @current = "#{@mana}/#{@max}"
  end

  def empty
    @mana = 0
    @current = "#{@mana}/#{@max}"
  end

  def spend(mana)
    @mana -= mana
    @current = "#{@mana}/#{@max}"
  end

  def empty?
    @mana.zero?
  end
end
