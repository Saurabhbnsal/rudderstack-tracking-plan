module Api
  module V1
    class TrackingPlansController < ApiController
      def create
        success, error_message, tracking_plan = TrackingPlan.create_plan(params)
        unless success
          return response_data({}, error_message, 422, error: {})
        end
        response_data({tracking_plan: tracking_plan.as_json} , message, 200, error: {})
      end

      def index
        response_data(TrackingPlan.all.as_json, 'All plans!', 200, error: {})
      end

      def update
        success, message, tracking_plan = TrackingPlan.update_plan(params)
        unless success
          return response_data({}, message, 422, error: {})
        end

        response_data(tracking_plan.as_json, message, 200, error: {})
      end

      def add_events
        id = params[:id]
        event_names = params[:event_names]
        tracking_plan = TrackingPlan.find_by(id: id)
        return response_data({}, 'Event names not present', 422, error: {}) if event_names.blank?
        return response_data({}, 'Tracking Plan not found', 422, error: {}) if tracking_plan.blank?

        events = Event.where(name: event_names)
        if events.size != event_names.size
          return response_data({}, 'Not all valid event names', 422, error: {})
        end
        event_ids = events.pluck(:id)
        if TrackingPlanToEventMapping.where(event_id: event_ids, tracking_plan_id: id).exists?
          return response_data({}, 'Some associations already exist', 422, error: {})
        end
        event_ids.each do |event_id|
          TrackingPlanToEventMapping.create(event_id: event_id, tracking_plan_id: id)
        end
        response_data(TrackingPlan.find_by(id: id).as_json, 'Successfully added associations',
                      200, error: {})
      end

      def remove_events
        id = params[:id]
        event_names = params[:event_names]
        tracking_plan = TrackingPlan.find_by(id: id)
        return response_data({}, 'Event names not present', 422, error: {}) if event_names.blank?
        return response_data({}, 'Tracking Plan not found', 422, error: {}) if tracking_plan.blank?

        events = Event.where(name: event_names)
        if events.size != event_names.size
          return response_data({}, 'Not all valid event names', 422, error: {})
        end
        event_ids = events.pluck(:id)
        tp_event_mappings = TrackingPlanToEventMapping.where(event_id: event_ids, tracking_plan_id: id)
        if tp_event_mappings.size != event_names.size
          return response_data({}, 'Some associations dont exist', 422, error: {})
        end
        tp_event_mappings.destroy_all

        response_data(TrackingPlan.find_by(id: id).as_json, 'Successfully added associations',
                      200, error: {})
      end

      def get_events
        id = params[:id]
        tracking_plan = TrackingPlan.find_by(id: id)
        return response_data({}, 'Tracking Plan not found', 422, error: {}) if tracking_plan.blank?
        event_ids = TrackingPlanToEventMapping.where(tracking_plan_id: id).pluck(:event_id)
        events = Event.where(id: event_ids)
        response_data(events.as_json, 'Events for the tracking plan',
                      200, error: {})
      end

      private

      def validate_rules(rules)
        event_ids = []
        unless rules[:events].blank?
          event_names = []
          events = rules[:events]
          events.each do |event|
            return [false, 'Event Parameters missing', event_ids] if event[:name].blank? || event[:rules].blank?
            event_names << event[:name]
          end
          return [false, 'Event name already exists', event_ids] if Event.where(name: event_names).exists?

          events.each do |event|
            event = Event.create(name: event[:name], description:  event[:description], rules:  event[:rules])
            event_ids << event.id
          end
        return [true, 'Events created', event_ids]
        end
        return [false, 'No events passed', event_ids]
      end
    end
  end
end