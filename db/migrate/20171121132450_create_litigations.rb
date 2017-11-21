class CreateLitigations < ActiveRecord::Migration[5.1]
  def change
    create_table :litigations do |t|
	    
	    t.string :number
	    t.string :origin
	    t.string :name
	    t.string :precedential
	    t.text :opinion_text

      t.timestamps
    end
  end
end
