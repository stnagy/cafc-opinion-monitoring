class Add < ActiveRecord::Migration[5.1]
  def change
  	add_column :litigations, :url, :text
  	add_column :litigations, :courtroom, :string
  	add_column :search_results, :email_date, :datetime
  end
end
