class TrackingPlansController < ApplicationController
  before_action :set_tracking_plan, only: [:show, :edit, :update]
  before_action :set_events, only: [:edit, :update, :new, :create]
  def index
    @tracking_plans = TrackingPlan.all
  end

  def new
    @tracking_plan = TrackingPlan.new
  end

  def edit; end

  def create
    @tracking_plan = TrackingPlan.new(tracking_plan_params)
    tracking_plan = params["tracking_plan"]
    name = tracking_plan["name"]
    description = tracking_plan["description"]
    events  = tracking_plan["events_attributes"]&.values

    respond_to do |format|
      if params[:add_event]
        @tracking_plan.events.build
        format.html { render :new, status: :unprocessable_entity }
      else

        success, message, @tracking_plan = TrackingPlan.create_plan(
          {name: name, description: description, events: events})
        if success
          # @tracking_plan = event
          format.html { redirect_to tracking_plans_path, notice: 'Event successfully updated.' }
          format.json { render :show, status: :created, location: @tracking_plan }
        else
          format.html { render :new }
          format.json { render json: message, status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    tracking_plan = params["tracking_plan"]
    name = tracking_plan["name"]
    events  = tracking_plan["events_attributes"]&.values
    description = tracking_plan["description"]
    respond_to do |format|
      if params[:add_event]
        @tracking_plan.events.build
        format.html { render :new, status: :unprocessable_entity }
      else
        success, message, @tracking_plan = TrackingPlan.update_plan(
          {name: name, description: description, events: events, id: params["id"]})

        if success
          # @tracking_plan = event
          format.html { redirect_to tracking_plans_path, notice: 'plan successfully updated.' }
          format.json { render :show, status: :created, location: @tracking_plan }
        else
          format.html { render :edit }
          format.json { render json: message, status: :unprocessable_entity }
        end
      end
    end
  end



  private

  def set_tracking_plan
    @tracking_plan = TrackingPlan.find(params[:id])
  end

  def tracking_plan_params
    params.require(:tracking_plan).permit(
      :name, :description, :rules,
      # tracking_plan_to_event_mappings_attributes:
      #   [:id, :_destroy, :tracking_plan_id, :event_id],
      events_attributes: [:id, :name, :description, :rules, :_destroy])
  end

  private

  def set_events
    @events = Event.all.order(id: :desc).pluck(:name, :id)
  end
end
