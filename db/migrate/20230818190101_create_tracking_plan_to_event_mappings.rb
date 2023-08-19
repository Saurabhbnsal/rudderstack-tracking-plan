class CreateTrackingPlanToEventMappings < ActiveRecord::Migration[7.0]
  def change
    create_table :tracking_plan_to_event_mappings do |t|
      t.references :events, foreign_key: true
      t.references :tracking_plans, foreign_key: true
      t.timestamps
    end
  end
end
