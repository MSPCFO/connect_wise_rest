module ConnectWiseRest
  class Report < Client

    attr_reader :name

    def initialize(name, options = {})
      @name = name
      @resource = '/system/reports/' + name
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def get(query = {})
      self.options[:query].merge!(query)
      @data = response.parsed_response
      format!
    end

    def format!
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
    end

  end
end