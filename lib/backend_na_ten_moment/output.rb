# frozen_string_literal: true

class Output
  def initialize(output: $stdout)
    @output = output
  end

  def print(string)
    print_to_console(string)
  end

  private

  def print_to_console(string)
    @output.puts(string)
  end

  def print_to_web; end
end
