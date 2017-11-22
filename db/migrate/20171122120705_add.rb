class Add < ActiveRecord::Migration[5.1]
  def change
  	add_column :litigations, :url, :text
  end
end
