class AddFieldsToLitigation < ActiveRecord::Migration[5.1]
  def change
  	
  	add_column :litigations, :status, :string
  	add_column :litigations, :status_date, :datetime
  
  end
end
