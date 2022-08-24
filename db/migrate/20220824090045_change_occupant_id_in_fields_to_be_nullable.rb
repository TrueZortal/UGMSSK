class ChangeOccupantIdInFieldsToBeNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :board_fields, :occupant_id, true
  end
end
