module Api
  module V1
    class SendEventApiController < ApiController
      require "json-schema"
      def send_event
        if params[:name].blank? || params[:properties].blank?
          return response_data({}, 'Wrong parameters', 422)
        end

        event = Event.find_by(name: params[:name])
        return response_data({}, 'Wrong parameters', 422) if event.nil?
        schema = event.rules
        success =  JSON::Validator.validate(schema, params[:properties])

        unless success
          return response_data({}, 'Wrong parameters', 500)
        end

        response_data({}, 'Validated event', 200)
      end
    end
  end
end