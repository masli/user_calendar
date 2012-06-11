# == Schema Information
# Schema version: 20100330111833
#
# Table name: events
#
#  id              :integer(4)      not null, primary key
#  title           :string(255)
#  starttime       :datetime
#  endtime         :datetime
#  all_day         :boolean(1)
#  created_at      :datetime
#  updated_at      :datetime
#  description     :text
#  event_series_id :integer(4)
#

class Event < ActiveRecord::Base
	attr_accessor :period, :frequency, :commit_button
  
	validates  :title, :description, :project_id, :presence=>true
	belongs_to :projects
  
	#  validate:validate

  
	def validate
		if (starttime >endtime) and !all_day
	
			errors.add(:base, "Start Time must be less than End Time")
		end
	end
  

  
  
  

	  

  
end
