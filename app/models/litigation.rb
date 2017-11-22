class Litigation < ApplicationRecord
	
	has_many :search_results
	has_many :searches, through: :search_results
	has_many :users, through: :searches
	
	def self.get_cafc_opinions
	
		# get page
		agent = Mechanize.new()
		agent.get("http://www.cafc.uscourts.gov/opinions-orders")
		
		# parse html
		html = Nokogiri::HTML(agent.page.content)
		table = html.css('table')
		
		# extract data
		# skip first row (header row)
		table.css('tr')[1..-1].each do |row|
			row_data = { status: "opinion" }
			row.css('td').each_with_index do |cell, index|
				
				# squish down the text
				cell_data = row.css('td')[index].text.squish
				
				# switch to fill in data according to column
				case index
					when 0
						row_data[:status_date] = Date.strptime(cell_data, "%Y-%m-%d")
					when 1
						row_data[:number] = cell_data
					when 2
						row_data[:origin] = cell_data
					when 3
						row_data[:name] = cell_data
						row_data[:url] = row.css('td')[index].css('a')[0]['href']
					when 4
						row_data[:precedential] = cell_data
				end
			end
			
			# find old litigation or create new one based
			# on case number and update
			litigation = Litigation.where(number: row_data[:number]).first_or_create	
			litigation.update(row_data)
		end
	end


end
