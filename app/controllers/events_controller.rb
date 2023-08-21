class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update]
  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def edit; end

  def create
    @event = Event.new
    event_params =  params[:event]
    event = {name: event_params[:name], description: event_params[:description], rules: event_params[:rules].as_json }
    success, message, event_id = Event.create_event(event)
    respond_to do |format|
      if success
        @event = Event.find(event_id)
        format.html { redirect_to events_path, notice: 'Event successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: message, status: :unprocessable_entity }
      end
    end
  end

  def show; end

  def update
    event_params =  params[:event]
    update_params = {}
    update_params[:id] = params[:id]
    update_params[:name] = event_params[:name]  if event_params[:name] != @event.name
    update_params[:description] = event_params[:description]  if event_params[:description] != @event.description
    update_params[:rules] = event_params[:rules]  if event_params[:rules] != @event.rules
    success, message, event = Event.update_event(update_params)
    respond_to do |format|
      if success
        @event = event
        format.html { redirect_to events_path, notice: 'Event successfully updated.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: message, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :description, :rules)
  end
end
