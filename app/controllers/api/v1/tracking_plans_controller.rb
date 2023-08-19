module Api
  module V1
    class TrackingPlansController < ApiController
      def create
        name = params[:name]
        description = params[:description]
        rules = params[:rules]

        if name.blank?
          return response_data({}, 'Missing params', 422, error: {})
        end
        if rules.present? & !validate_rules(rules)

        end

      end

      def index

      end

      private

      def validate_rules(rules)

      end
    end
  end
end