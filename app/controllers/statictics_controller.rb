class StaticticsController < ApplicationController
	def index

		all_events=Event.all
		events = []
		all_events.each do |event|
			
		end

		data_table = GoogleVisualr::DataTable.new
		data_table.new_column('string', 'Year' )
		data_table.new_column('number', 'Sales')
		data_table.new_column('number', 'Expenses')

		# Add Rows and Values
		data_table.add_rows([
				['2004', 1000, 400],
				['2005', 1170, 460],
				['2006', 660, 1120],
				['2007', 1030, 540]
			])
		option = { :width=> 400, :height=> 240, :title=> 'Company Performance' }
		@chart = GoogleVisualr::Interactive::AreaChart.new(data_table, option)



	end

end
