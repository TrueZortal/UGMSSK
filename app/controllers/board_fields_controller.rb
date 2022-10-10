class BoardFieldsController < ApplicationController
  def show
    p params
    @field = BoardField.find(params['id'])
  end

  def refresh_fields
    p "apdejt hehe"
    p params
    @field = BoardField.find(params['id'])
    p @field

    respond_to do |format|
      format.html
      format.turbo_stream { render "games/replace" }
    end

  end

  # TODO: wypieprzyc
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
