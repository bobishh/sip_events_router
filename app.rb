# frozen_string_literal: true

require 'bundler'
require 'json'
require 'sinatra/json'
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
require 'redis_subscription'
require 'redis_publication'

REDIS_CONNECTION = ENV['REDIS_CONNECTION']
REDIS_QUEUE_NAME = ENV['REDIS_QUEUE_NAME']
MANGO_KEY = ENV['MANGO_API_KEY']
MANGO_SALT = ENV['MANGO_API_SALT']

Bundler.require

Faye::WebSocket.load_adapter('puma')

set :bind, '0.0.0.0'
set :port, 4242

get '/' do
  erb :index
end

get '/:channel' do
  if Faye::WebSocket.websocket?(request.env)
    ws = Faye::WebSocket.new(request.env)
    subscription = RedisSubscription.new(params[:channel],
                                         queue: REDIS_QUEUE_NAME,
                                         redis_config: REDIS_CONNECTION)

    ws.on(:open) do
      subscription.activate! do |pubsub, channel|
        pubsub.on(:message) do |_ch, msg|
          ws.send(msg) if JSON.parse(msg)['to'] == channel
        end
      end
    end

    ws.on(:close) { subscription.cancel! }
    ws.rack_response
  else
    status 200
  end
end

post '/events/:event_type' do
  return status(403) unless MangoValidator.new(params, MANGO_KEY, MANGO_SALT).valid?
  payload = JSON.parse(params[:json])
  RedisPublication.new({ event_type: params[:event_type],
                         from: payload['from']['number'],
                         to: payload['to']['number'] }.to_json,
                       queue: REDIS_QUEUE_NAME,
                       redis_config: REDIS_CONNECTION)
  status 200
end
