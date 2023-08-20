module Api
  module V1
    class EventsController < ApiController

      def create
        name = params[:name]
        description = params[:description]
        rules = params[:rules]
        if name.blank? || description.blank? || rules.blank?
          return response_data({}, 'Missing params', 422, error: {})
        end

        if name_exists(name)
          return response_data({}, 'Event with this name already exists', 422, error: {})
        end

        event = Event.create(name: name, description: description, rules: rules)
        response_data({event_id: event.id} , 'Successfully created event!', 200, error: {})
      end

      def index
        response_data(Event.all.as_json, 'All events!', 200, error: {})
      end

      def update
        id = params[:id]
        event = Event.find_by(id: id)
        return response_data({}, 'Event not found', 422, error: {}) if event.blank?
        if params[:name].present? && name_exists(params[:name])
          return response_data({}, 'Event with this name already exists', 422, error: {})
        end
        event.name = params[:name] if params[:name].present?
        event.description = params[:description] if params[:description].present?
        event.rules = params[:rules] if params[:rules].present?
        event = event.save
        response_data(event.as_json, 'Updated event!', 200, error: {})
      end

      private

      def name_exists(name)
        Event.where(name: name).exists?
      end

    end
  end
end