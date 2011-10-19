class EventsController < ApplicationController


	def create

		

		
			@event = Event.new(params[:event])
			if params[:event][:all_day]=='0'
				@event[:all_day]=false
			end

			

#		starttime=params[:event][:starttime]
#		endtime=params[:event][:endtime]
#
#
#		array_of_dates=array_of_valid_dates(starttime,endtime)

			

			if @event
				if @event.save
					redirect_to :back
				else
					redirect_to :back,:notice=> @event.errors.full_messages(',').join("\n")
				end

			end

		


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

protected
	def array_of_valid_dates(starttime,endtime)

		
	end
	
end
