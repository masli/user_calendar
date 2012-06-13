class Event < ActiveRecord::Base

  attr_accessor :period, :frequency, :commit_button
  
	validates  :title, :description, :project_id, :presence=>true

	belongs_to :projects
  
  validate:validate_time

	def validate_time
		if (starttime >endtime) and !all_day
			errors.add(:base, "Start Time must be less than End Time")
		end
	end
  
end
