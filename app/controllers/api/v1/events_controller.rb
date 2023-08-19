module Api
  module V1
    class EventsController < ApiController

      def create
        name = params[:name]
        description = params[:description]
        rules = params[:rules]
        puts '!!!!!!!!!!!!!!!!!!'
        puts name
        puts description
        puts rules
        puts name.blank?
        if name.blank? || description.blank? || rules.blank?
          return response_data({}, 'Missing params', 422, error: {})
        end

        if name_exists(name)
          return response_data({}, 'Event with this name already exists', 422, error: {})
        end

        unless validate_rules(rules)
          return response_data({}, 'Wrong rules format', 422, error: {})
        end

        event = Event.create(name: name, description: description, rules: rules)
        response_data({event_id: event.id} , 'Successfully created event!', 200, error: {})
      end

      def index

      end

      private

      def name_exists(name)
        Event.where(name: name).exists?
      end

      def validate_rules(rules)

      end

    end
  end
end