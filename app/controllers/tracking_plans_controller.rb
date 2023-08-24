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

  def update
    puts params
    # puts params[:]
    respond_to do |format|
      if params[:add_event]
        # p
        @tracking_plan.events.build
        format.html { render :new, status: :unprocessable_entity }
      else
        ###change all this and make it like in events
        if @tracking_plan.save
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



  private

  def set_tracking_plan
    @tracking_plan = TrackingPlan.find(params[:id])
  end

  def tracking_plan_params
    params.require(:tracking_plan).permit(
      :name, :description, :rules,
      tracking_plan_to_event_mappings_attributes:
        [:id, :_destroy, :tracking_plan_id, :event_id],
      events_attributes: [:id, :name, :description])
  end

  private

  def set_events
    @events = Event.all.order(id: :desc).pluck(:name, :id)
  end
end
