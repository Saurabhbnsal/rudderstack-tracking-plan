class TrackingPlan < ApplicationRecord
  has_many :tracking_plan_to_event_mappings, dependent: :destroy
  has_many :events, through: :tracking_plan_to_event_mappings
  accepts_nested_attributes_for :tracking_plan_to_event_mappings, allow_destroy: true
  accepts_nested_attributes_for :events, allow_destroy: true

  def self.create_plan(params)
    name = params[:name]
    description = params[:description]
    rules = params[:rules]
    events = params[:events]

    return [false, 'Missing params', nil] if name.blank?

    event_ids = []
    if events.present?
      events = TrackingPlan.sanitize_events(events)
      rules=  {}
      rules[:events] = events
    end
    if rules.present?
      success, error_message, event_ids = TrackingPlan.validate_rules(rules)
      return [false, error_message, nil] if !success
    end
    tracking_plan = TrackingPlan.create(name: name, description: description)
    unless event_ids.blank?
      event_ids.each do |event_id|
        TrackingPlanToEventMapping.create(tracking_plan_id: tracking_plan.id, event_id: event_id)
      end
    end
    [true, 'Successfully created Tracking plan!', tracking_plan]
  end

  def self.update_plan(params)
    id = params[:id]
    tracking_plan = TrackingPlan.find_by(id: id)
    return [false, 'Tracking Plan not found', nil] if tracking_plan.blank?
    events = params[:events]
    event_ids = []
    rules=  {}
    if events.present?
      events = TrackingPlan.sanitize_events(events)
      rules[:events] = events
    end
    if rules.present?
      success, error_message, event_ids = TrackingPlan.validate_rules(rules, true, tracking_plan.id)
      return [false, error_message, nil] if !success
    end
    tracking_plan.name = params[:name] if params[:name].present?
    tracking_plan.description = params[:description] if params[:description].present?
    tracking_plan = tracking_plan.save
    unless event_ids.blank?
      event_ids.each do |event_id|
        TrackingPlanToEventMapping.create(tracking_plan_id: id, event_id: event_id)
      end
    end
    [true, 'Updated tracking plan!', tracking_plan]
  end

  def self.add_events

  end

  def self.remove_events

  end

  def self.validate_rules(rules, is_update=false, tracking_plan_id = nil)
    return [false, 'Event Parameters missing', nil] if rules.blank?
    event_ids = []
    unless rules[:events].blank?
      event_names = []
      events = rules[:events]
      events.each do |event|
        return [false, 'Event Parameters missing', event_ids] if event[:name].blank? || event[:rules].blank?
        event_names << event[:name]
      end
      if Event.where(name: event_names).exists?
        unless is_update
          return [false, 'Event name already exists', event_ids]
        end
      end

      events.each do |event|
        if is_update
          old_event = Event.find_by(name: event[:name])
          if old_event.present?
            if !event[:remove]
              next
            elsif is_update && event[:remove]
              event_id = Event.find_by(name: event[:name]).id
              TrackingPlanToEventMapping.where(event_id: event_id, tracking_plan_id: tracking_plan_id).last&.destroy
              next
            end
          end
        end
        event = Event.create(name: event[:name], description:  event[:description], rules:  event[:rules])
        event_ids << event.id
      end
      return [true, 'Events created', event_ids]
    end
    return [false, 'No events passed', event_ids]
  end

  def self.sanitize_events(events)
    sanitized_events = []
    events.each do |event|
        sanitized_events << {
          name: event["name"],
          description: event["description"],
          rules: event["rules"],
          remove: event["_destroy"] == "1"
        }
    end
    sanitized_events
  end

end
