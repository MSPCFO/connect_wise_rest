module ConnectWiseRest
  class Request

    attr_reader :resource, :options, :client

    DEFAULT_OPTIONS = {
        timeout: 300,
        query: { 'page' => 1, 'pageSize' => 75 }
    }

    def initialize(resource, options = {}, client = ConnectWiseRest.client)
      @resource = resource[0] == '/' ? resource : "/#{resource}"
      @options = DEFAULT_OPTIONS.merge(options)
      @client = client
    end

    def data
      @data || fetch
    end

    def fetch
      @response = nil
      response

      if response.response.is_a?(Net::HTTPInternalServerError)
        raise "#{response.parsed_response['code']}: #{response.parsed_response['message']}"
      end

      @data = response.parsed_response
    end

    def response
      @response ||= HTTParty.get(url, request_options)
    end

    def request_options
      request_options = {
          headers: { 'Accept' => 'application/json' },
          query: self.options[:query],
          timeout: self.options[:timeout],
          basic_auth: {
              username: "#{self.client.config.company_id}+#{self.client.config.public_key}",
              password: self.client.config.private_key
          }
      }

      request_options[:debug_output] = ConnectWiseRest.logger if self.client.config.debug

      request_options
    end

    def url
      "https://#{self.client.config.url_prefix}/v4_6_release/apis/#{self.client.config.version}#{resource}"
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