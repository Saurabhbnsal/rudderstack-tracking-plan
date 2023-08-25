# README

Please read this file before using the app. 

 - To create an event - 
You can either visit https://rudderstack-tracking-plan.onrender.com/events/new or 
use the following API in POST - https://rudderstack-tracking-plan.onrender.com/api/v1/events/
with payload -   {
                    "name": "Order Viewed",
                    "description": "Whose order viewed",
                    "rules": {
                        "$schema": "http://json-schema.org/draft-07/schema#",
                        "type": "object",
                        "properties": {
                            "type": "object",
                            "properties": {
                                "product": {
                                    "type": ["string"]
                                },
                                "price": {
                                    "type": ["number"]
                                },
                                "currency": {
                                    "type": ["string"]
                                }
                            },
                            "required": [
                                "product",
                                "price",
                                "currency"
                            ]
                        }
                    }

- To get all events - GET - https://rudderstack-tracking-plan.onrender.com/api/v1/events/ or visit
https://rudderstack-tracking-plan.onrender.com/events/new

- To edit an event visit - https://rudderstack-tracking-plan.onrender.com/events/:id/edit or c
call in PUT https://rudderstack-tracking-plan.onrender.com/api/v1/events/:id and pass the 
fields to be edited.


- For tracking plans - 
- To get all - GET - https://rudderstack-tracking-plan.onrender.com/api/v1/tracking_plans/ or visit
  https://rudderstack-tracking-plan.onrender.com/tracking_plans

- To create a tracking plan -
 You can either visit https://rudderstack-tracking-plan.onrender.com/tracking_plans/new or
 use the following API in POST - https://rudderstack-tracking-plan.onrender.com/api/v1/tracking_plans/
 and use the payload as specified in thew requirement doc
- 
- To edit a tracking plan- https://rudderstack-tracking-plan.onrender.com/tracking_plans/:id/edit or c
  call in PUT https://rudderstack-tracking-plan.onrender.com/api/v1/tracking_plans/:id and pass the
  fields to be edited.

- To add event to a tracking plan - 
use the api - https://rudderstack-tracking-plan.onrender.com/api/v1/tracking_plans/add_events/:id
and pass the payload as 
{"event_names: [names of events to be added] }

- To remove event to a tracking plan -
  use the api - https://rudderstack-tracking-plan.onrender.com/api/v1/tracking_plans/remove_events/:id
  and pass the payload as
  {"event_names: [names of events to be added] }






