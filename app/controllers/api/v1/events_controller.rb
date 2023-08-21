module Api
  module V1
    class EventsController < ApiController

      def create
        success, message, event_id = Event.create_event(params)
        unless success
          return response_data({}, message, 422, error: {})
        end
        response_data({event_id: event_id} , message, 200, error: {})
      end

      def index
        response_data(Event.all.as_json, 'All events!', 200, error: {})
      end

      def update
        success, message, event = Event.update_event(params)
        unless success
          return response_data({}, message, 422, error: {})
        end

        response_data(event.as_json, 'Updated event!', 200, error: {})
      end
    end
  end
end