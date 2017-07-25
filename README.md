# Calling events retranslator
## Project aimed to pass calling events to CRM

1) Opens websocket connection with a client registered with user number
2) Subscribes to Redis's channel
3) Receives a webhook at /events/:event_type
4) Translates redis events to websocket channel if event 'to' field matches with user number

## RUN
### You need redis running on a local machine
```
$ bundle install
$ bundle exec ruby app.rb
```
