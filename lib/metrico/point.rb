module Metrico
  class Point
    attr_accessor :name, :tags, :fields

    def initialize(name, fields, tags = {})
      @name = measurement(name)
      @fields = escape_fields(fields)
      tags = { hostname: Metrico.config.hostname }.merge(tags)
      @tags = escape_tags(tags)
    end

    # https://docs.influxdata.com/influxdb/v1.3/write_protocols/line_protocol_tutorial/
    # InfluxDB Line Protocol
    # weather,location=us-midwest temperature=82 1465839830100400200
    #   |    -------------------- --------------  |
    #   |             |             |             |
    #   |             |             |             |
    # +-----------+--------+-+---------+-+---------+
    # |measurement|,tag_set| |field_set| |timestamp|
    # +-----------+--------+-+---------+-+---------+
    def to_s
      str = "#{name}"
      str << ",#{tags}" if tags
      str << " #{fields}"
      str << " #{timestamp}"
      str
    end

    private def measurement(name)
      escape("#{Metrico.config.app_name}:#{name}", :measurement)
    end

    private def timestamp
      (Time.now.to_f * 1_000_000_000).to_i
    end

    private def escape_tags(tags)
      return if tags.nil?

      tags = tags.map do |k, v|
        key = escape(k.to_s, :tag_key)
        val = escape(v.to_s, :tag_value)

        "#{key}=#{val}" unless key == "".freeze || val == "".freeze
      end.compact

      tags.join(",") unless tags.empty?
    end

    private def escape_fields(fields)
      return if fields.nil?
      fields.map do |k, v|
        key = escape(k.to_s, :field_key)
        val = escape_value(v)
        "#{key}=#{val}"
      end.join(",".freeze)
    end

    private def escape_value(value)
      if value.is_a?(String)
        '"'.freeze + escape(value, :field_value) + '"'.freeze
      elsif value.is_a?(Integer)
        "#{value}i"
      else
        value.to_s
      end
    end

    private def escape(string, type)
      # rubocop:disable Layout/AlignParameters
      string = string.encode(
        'UTF-8'.freeze,
        'UTF-8'.freeze,
        invalid: :replace,
        undef: :replace,
        replace: ''.freeze
      )
      
      ESCAPES[type].each do |char|
        string = string.gsub(char) { "\\#{char}" }
      end
      string
    end

    ESCAPES = {
      measurement:  [' '.freeze, ','.freeze],
      tag_key:      ['='.freeze, ' '.freeze, ','.freeze],
      tag_value:    ['='.freeze, ' '.freeze, ','.freeze],
      field_key:    ['='.freeze, ' '.freeze, ','.freeze, '"'.freeze],
      field_value:  ["\\".freeze, '"'.freeze],
    }.freeze

  end
end
