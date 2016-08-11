module ConnectWiseRest
  class Client

    attr_accessor :options
    attr_reader :resource

    DEFAULT_OPTIONS = ConnectWiseRest.configuration.to_hash.merge(
        {
            timeout: 300,
            query: { 'page' => 1, 'pageSize' => 75 }
        }
    )

    def initialize(resource, options = {})
      @resource = resource
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def data
      @data || fetch
    end

    def fetch(query = {})
      self.options[:query].merge!(query)

      @response = nil
      response

      if response.response.is_a?(Net::HTTPInternalServerError)
        raise "#{response.parsed_response['code']}: #{response.parsed_response['message']}"
      end

      @data = response.parsed_response
    end

    def response
      @response ||= HTTParty.get(
          url,
          headers: { 'Accept' => 'application/json' },
          query: self.options[:query],
          timeout: options[:timeout]
      )
    end

    def url
      url = "https://#{options[:company_id]}+#{options[:public_key]}:#{options[:private_key]}"
      url += "@#{options[:url_prefix]}"
      url += "/#{options[:code]}/apis/#{options[:version]}"
      url += resource

      return url
    end

    ### Pagination ###

    def next_page?
      self.data.is_a?(Array) && self.data.count == self.options[:query]['pageSize']
    end

    def next_page
      self.options[:query]['page'] += 1
      return fetch
    end

    def previous_page?
      self.options[:query]['page'] > 1
    end

    def previous_page
      self.options[:query]['page'] -= 1
      return fetch
    end

  end
end