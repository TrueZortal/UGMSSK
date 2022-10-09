class BoardFieldsController < ApplicationController
  def show
    p params
    @field = BoardField.find(params['id'])
  end

  def update
    p params
    @field = BoardField.find(params['id'])
    if @field.update
      respond_to do |format|
        format.html { redirect_to quotes_path, notice: "Quote was successfully updated." }
        format.turbo_stream
      end
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def field_params
  end
end
