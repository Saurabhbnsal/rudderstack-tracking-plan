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
  end

  private

  def set_tracking_plan
    @tracking_plan = TrackingPlan.find(params[:id])
  end

  def tracking_plan_params
    params.require(:tracking_plan).permit(
      :name, :description, :rules,
      tracking_plan_to_event_mappings_attributes:
        [:id, :_destroy, :tracking_plan_id, :event_id])
  end

  private

  def set_events
    @events = Event.all.order(id: :desc).pluck(:name, :id)
  end
end
