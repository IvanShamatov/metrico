module Metrico
  class Point
    attr_accessor :name, :tags, :fields

    def initialize(name, fields, tags = {})
      @name = name
      @fields = fields
      tags = { hostname: Metrico.config.hostname }.merge(tags)
      @tags = tags
    end

    # https://docs.influxdata.com/influxdb/v1.2/write_protocols/line_protocol_tutorial/
    # InfluxDB Line Protocol
    def to_s
      [
        metric_name,
        metric_props
      ].join(',')
    end

    private def metric_name
      [Metrico.config.app_name, name].join(':')
    end

    private def metric_props
      [
        comma_equal_flatten(tags),
        comma_equal_flatten(fields),
        timestamp
      ].join(' ')
    end

    private def timestamp
      (Time.now.to_f * 1_000_000_000).to_i
    end

    private def comma_equal_flatten(hash)
      hash.map { |k, v| [k, v].join('=') }.join(',')
    end
  end
end
