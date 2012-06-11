class DayEvent < ActiveRecord::Base
	

	validates  :title, :description, :project_id, :presence=>true
  

 

end
