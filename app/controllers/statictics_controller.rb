class StaticticsController < ApplicationController
	def index

		DayEvent.delete_all
		all_events=Event.all
		
		all_events.each do |event|
			title_event=event[:title]
			all_day=event[:all_day]
			description=event[:description]
			project_id=event[:project_id]
			user_id=event[:user_id]


			starttime=DateTime.parse(event[:starttime].to_s)
			endtime=DateTime.parse(event[:endtime].to_s)

			while starttime<=endtime
				day_event=starttime
				if(starttime==endtime)
					day_event=starttime-1.day
				end
				day_event = DayEvent.new(:title=>title_event,:day=>day_event,:all_day=>all_day,:description=>description,:project_id=>project_id,:user_id=>user_id)
				day_event.save
				starttime=starttime+1.day
			end


		end

		options = {
         
			:group => 'day_events.day',
			:order => 'day DESC' }



		events_for_timeline=DayEvent.count(options)
		events_for_timeline=events_for_timeline

		

		data_table = GoogleVisualr::DataTable.new


		data_table.new_column('date', 'Date' )
		data_table.new_column('number', 'numar evenimente')
		row=0;
		events_for_timeline.each do |event|

			numar=event[1];
			date=DateTime.parse(event[0].to_s)

			row=[date,numar]
			data_table.add_row(row)
			
		end

		

	
		opts   = { :displayAnnotations => true ,:title=>"Some title"}
		@chart = GoogleVisualr::Interactive::AnnotatedTimeLine.new(data_table, opts)



		count_monday=0
		count_tuesday=0
		count_wednesday=0
		count_thursday=0
		count_friday=0

		some_events=DayEvent.all
		
		some_events.each do |event|


			sd=DateTime.parse(event[:day].to_s)
			

			start=sd.strftime("%A")

			if(start=="Monday")
				count_monday +=1
			else if start=="Tuesday"
					count_tuesday +=1
				else
					if start=="Wednesday"
						count_wednesday+=1
					else
						if start=="Thursday"
							count_thursday+=1
						else if start=="Friday"
								count_friday +=1
							end
						end
					end

				end
			end

		end


		data_table = GoogleVisualr::DataTable.new
		data_table.new_column('string', 'Day of Week')
		data_table.new_column('number', 'Hours per Day')
		data_table.add_rows(5)
		data_table.set_cell(0, 0, 'Monday' )
		data_table.set_cell(0, 1, count_monday )
		data_table.set_cell(1, 0, 'Tuesay' )
		data_table.set_cell(1, 1, count_tuesday )
		data_table.set_cell(2, 0, 'Wednesday' )
		data_table.set_cell(2, 1, count_wednesday )
		data_table.set_cell(3, 0, 'Thursday' )
		data_table.set_cell(3, 1, count_thursday )
		data_table.set_cell(4, 0, 'Friday' )
		data_table.set_cell(4, 1, count_friday )

		opts = { :width => 400, :height => 240, :title => 'My Daily Activities', :is3D => true }
		@pie_chart = GoogleVisualr::Interactive::PieChart.new(data_table, opts)





	end

end
