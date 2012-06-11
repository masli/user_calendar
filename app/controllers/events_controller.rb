class EventsController < ApplicationController


	def create

		

		
		@event = Event.new(params[:event])
		if params[:event][:all_day]=='0'
			@event[:all_day]=false
		end

			

		create_events_to_database(@event)

		


	end
  
	def index
    
	end
  
  
	def get_events
		@events = Event.find(:all,:conditions => {:user_id => current_user[:id]})
		events = []
		@events.each do |event|
			events << {:id => event.id, :title => event.title, :description => event.description || "Some cool description here...", :start => "#{event.starttime.iso8601}", :end => "#{event.endtime.iso8601}", :allDay => event.all_day, :recurring => (event.project_id)? true: false}
		end

		events=events.to_json
		

		render :text=>events

		





	end
  
	def show
		
	end
  
	def move
		@event = Event.find_by_id params[:id]
		if @event
			@event.starttime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.starttime))
			@event.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
			@event.all_day = params[:all_day]
			@event.save
		end
		render :text=>""


	end
  
  
	def resize
		@event = Event.find_by_id params[:id]
		if @event
			@event.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
			@event.save
		end
		render :text=>""
	end
  
	def edit
		@event = Event.find_by_id(params[:id])

		
		render :partial => 'events/edit_form', :object => @event
		
			
	end
  
	def update
		@event = Event.find_by_id(params[:event][:id])
		
		@event.attributes = params[:event]
		@event.save
		

		redirect_to :back


	
	end
  
	def destroy
		@event = Event.find_by_id(params[:id])
		@event.destroy
		render :text=>""

    
	end






	def create_events_to_database(event_principal)

		title_event=event_principal[:title]
		all_day=event_principal[:all_day]
		description=event_principal[:description]
		project_id=event_principal[:project_id]
		user_id=event_principal[:user_id]


		starttime=DateTime.parse(event_principal[:starttime].to_s).to_date
		endtime=event_principal[:endtime]

		myDays=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
		list_of_Holidays=["1-1","2-1","8-3","19-4","20-4","1-5","1-6","8-6","12-6","16-6","26-6","29-6","29-7","15-8","1-12","8-12","25-12","26-12"];

		start_day_of_week=starttime.strftime("%A")
		end_day_of_week=endtime.strftime("%A")

		ziua=starttime.day
		luna=starttime.month
		string=""+ziua.to_s+"-"+luna.to_s+""

		ziua=endtime.day
		luna=endtime.month
		string2=""+ziua.to_s+"-"+luna.to_s+""



		if list_of_Holidays.index(string)
			redirect_to :back,:notice=>"the start day is a holiday"

		else

			if list_of_Holidays.index(string2)
				redirect_to :back,:notice=>"the end day is a holiday"

			else


				if start_day_of_week=="Sunday" || start_day_of_week=="Saturday"


					redirect_to :back,:notice=>"The start day should not be "+start_day_of_week.to_s

				else
					if end_day_of_week=="Sunday" || end_day_of_week=="Saturday"


						redirect_to :back,:notice=>"The end day should not be "+end_day_of_week.to_s

					else

						sd=Date.parse(event_principal[:starttime].to_s)
						ed=Date.parse(event_principal[:endtime].to_s)
						somevar=1



						events=[]



						if sd<ed
							start=sd



							while sd<=ed
								sd=sd+somevar.day
								start_day_of_week=sd.strftime("%A")
								string=""+sd.day.to_s+"-"+sd.month.to_s+""
								if list_of_Holidays.index(string)!=nil

									events << {:start=>start , :end=>sd-1.day}
									sd=sd+somevar.day
									start=sd

								end
								if start_day_of_week=="Saturday"
									events << {:start=>start , :end=>sd-1.day}
									sd=sd+2.day
									start=sd


								end


							end

							events << {:start=>start , :end=>sd-1.day}


							events.each do |eveniment|

								@event = Event.new(:title=>title_event,:starttime=>nil,:endtime=>nil,:all_day=>all_day,:description=>description,:project_id=>project_id,:user_id=>user_id)
								if event_principal[:all_day]=='0'
									@event[:all_day]=false
								end
								@event[:starttime]=eveniment[:start]
								@event[:endtime]=eveniment[:end]+1.day


								@event.save




							end
							redirect_to :back
							#
							# render :text =>events.to_json
						else
							@event = Event.new(:title=>title_event,:starttime=>starttime,:endtime=>endtime,:all_day=>all_day,:description=>description,:project_id=>project_id,:user_id=>user_id)
							if event_principal[:all_day]=='0'
								@event[:all_day]=false
							end

							if @event
								if @event.save
									redirect_to :back
								else
									redirect_to :back,:notice=> @event.errors.full_messages(',').join("\n")
								end

							end

						end





					end

				end
			end

		end



	end







	
	
end
