class CreateSearchResults < ActiveRecord::Migration[5.1]
  def change
    create_table :search_results do |t|
	    
	    t.references :search
	    t.references :litigation

      t.timestamps
    end
  end
end
