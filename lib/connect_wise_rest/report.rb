module ConnectWiseRest
  class Report < Request

    attr_reader :name

    def initialize(name, options = {}, client = ConnectWiseRest.client)
      super

      @name = name
      @resource = '/system/reports/' + name
    end

    def fetch
      super
      format!
    end

    def format!
      if @data['row_values'].is_a?(Array)
        rows = []

        @data['row_values'].each do |values|
          row = {}

          values.each_with_index do |value, index|
            key = @data['column_definitions'][index].keys[0]
            row[key] = value
          end

          rows << row
        end

        @data = rows

      else
        @data = []
      end
    end

  end
end