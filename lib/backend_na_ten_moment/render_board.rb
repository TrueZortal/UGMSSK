# frozen_string_literal: true

class RenderBoard
  @@RENDER_KEY = {
    'dirt': '🟫',
    'tree': '🌲',
    'house': '🏠',
    'grass': '🟩'
  }

  def self.render(rowified_board)
    rendered_board = String.new(encoding: 'UTF-8')
    columns = rowified_board.size - 1
    rowified_board.transpose.each_with_index do |row, index|
      row.each do |field|
        rendered_board << if field.is_occupied?
                            field.occupant.symbol + field.occupant.owner.chr
                          else
                            @@RENDER_KEY[field.terrain.to_sym]
                          end
      end
      rendered_board << "\n" if index < rowified_board.size - 1
    end

    board_with_field_identifiers = []
    rendered_board.lines.each_with_index do |line, index|
      board_with_field_identifiers << ["#{index} #{line}"]
    end
    board_with_field_identifiers.unshift("  #{(0..columns).to_a.join(' ')}\n")
    board_with_field_identifiers.join
  end
end
