class TrackingPlanToEventMapping < ApplicationRecord
  belongs_to :tracking_plan
  belongs_to :event
end
