# frozen_string_literal: true

require 'json'
require 'em-hiredis'

class RedisSubscription
  attr_reader :queue, :channel, :redis_config

  def initialize(channel, options)
    @channel = channel
    @queue = options[:queue]
    @redis_config = options[:redis_config]
  end

  def activate!
    EM.run {
      pubsub.subscribe(queue)
      yield(pubsub, channel) if block_given?
    }
  end

  def cancel
    pubsub.unsubsribe(queue)
  end

  private

  def pubsub
    @pubsub ||= init_redis
  end

  def init_redis
    EM.run {
      @redis = EM::Hiredis.connect(redis_config)
      @redis.pubsub
    }
  end
end
