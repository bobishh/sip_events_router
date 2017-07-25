# frozen_string_literal: true

require 'em-hiredis'

class RedisPublication
  attr_reader :result, :redis_config

  def initialize(data, options)
    EM.run {
      @redis_config = options[:redis_config]
      connection = EM::Hiredis.connect(redis_config)
      @result = connection.publish(options[:queue], data)
    }
  end
end
