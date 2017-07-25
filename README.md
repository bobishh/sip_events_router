# SIP events router

## Project aimed to pass calling events to CRM

1) Opens websocket connection with a client registered with user id (sip or number)
2) Subscribes to Redis's channel
3) Receives a webhook at ```/events/:event_type```
4) Translates redis events to websocket channel if event 'to' field matches with user number

## RUN
1) ``` docker-compose up ```
2) ```GET localhost:4242/``` - and look for channel id in browser console
3) ```POST localhost:4242/_CHANNEL_ID_``` with data formatted as supposed in Mango docs
4) PROFIT!
