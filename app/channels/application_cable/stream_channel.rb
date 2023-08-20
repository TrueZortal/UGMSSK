class StreamsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "board_fields"
  end
end
