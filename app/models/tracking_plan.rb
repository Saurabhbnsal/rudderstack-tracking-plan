class TrackingPlan < ApplicationRecord
  has_many :tracking_plan_to_event_mappings, dependent: :destroy
  has_many :events, through: :tracking_plan_to_event_mappings
  accepts_nested_attributes_for :tracking_plan_to_event_mappings, allow_destroy: true
end
