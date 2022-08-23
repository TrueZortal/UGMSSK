# frozen_string_literal: true

class RenderBoard
  @@RENDER_KEY = {
    'dirt': '🟫',
    'tree': '🌲',
    'house': '🏠',
    'grass': '🟩'
  }

  def self.render(columnised_board)
    web_render(columnised_board)
    # console_render(columnised_board)
    # render_to_json(columnised_board)
  end

  def self.web_render(columnised_board)
    edge_size = columnised_board.size - 1
    board = columnised_board.transpose.flatten(1)
    display_board = []
    board.each do |field|
      display_board << field.display = if field.occupied?
                                        #  field.occupant.symbol + field.occupant.owner.chr
                                       else
                                         @@RENDER_KEY[field.terrain.to_sym]
                                         # field.position.to_a.to_s
                                         # field
                                       end
    end
    board.each_slice(columnised_board.size).to_a
  end

  def self.render_to_json(columnised_board)
    edge_size = columnised_board.size - 1
    board = columnised_board.transpose.flatten(1)
    array_of_json_representations_of_fields = board.map(&:make_json)

    array_of_json_representations_of_fields.each_slice(columnised_board.size).to_a
  end

  def self.render_from_json(board_json); end

  def self.console_render(columnised_board)
    rendered_board = []
    columns = columnised_board.size - 1
    columnised_board.transpose.each_with_index do |row, _index|
      row.each do |field|
        rendered_board << if field.occupied?
                            # field.occupant.symbol + field.occupant.owner.chr
                          else
                            @@RENDER_KEY[field.terrain.to_sym]
                            # field.position.to_a.to_s
                            # field
                          end
      end
      # rendered_board << "\n" if index < columnised_board.size - 1
    end
    rendered_board = rendered_board.each_slice(columnised_board.size).to_a
    rendered_board.unshift((0..columns).to_a)
    rendered_board
    # board_with_field_identifiers = []
    # rendered_board.lines.each_with_index do |line, index|
    #   board_with_field_identifiers << ["#{index} #{line}"]
    # end
    # board_with_field_identifiers.unshift("  #{(0..columns).to_a.join(' ')}\n")
    # board_with_field_identifiers.join.split("\n")
  end
end
