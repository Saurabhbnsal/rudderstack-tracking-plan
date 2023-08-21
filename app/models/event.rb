class Event < ApplicationRecord

  def self.create_event(params)
    name = params[:name]
    description = params[:description]
    rules = params[:rules]
    if name.blank? || description.blank? || rules.blank?
      return [false, 'Missing params', nil]
    end

    if self.name_exists(name)
      return [false, 'Event with this name already exists', nil]
    end

    event = Event.create(name: name, description: description, rules: rules)
    return [true, 'Event Created Successfully', event.id]
  end

  def self.update_event(params)
    id = params[:id]
    event = Event.find_by(id: id)
    return [false, 'Event doesn;t exist', event] if event.blank?

    if params[:name].present? && name_exists(params[:name])
      return [false, 'Event with this name already exists', event]
    end
    event.name = params[:name] if params[:name].present?
    event.description = params[:description] if params[:description].present?
    event.rules = params[:rules] if params[:rules].present?
    event = event.save
    return [true, 'Event updated Successfully', event]
  end

  def self.name_exists(name)
    Event.where(name: name).exists?
  end
end
