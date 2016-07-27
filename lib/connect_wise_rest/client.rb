module ConnectWiseRest
  class Client

    attr_accessor :options

    attr_reader :resource, :response

    DEFAULT_OPTIONS = {
        company_id: ConnectWiseRest.configuration.company_id,
        public_key: ConnectWiseRest.configuration.public_key,
        private_key: ConnectWiseRest.configuration.private_key,
        url_prefix: ConnectWiseRest.configuration.url_prefix,
        version: ConnectWiseRest.configuration.version,
        query: { 'page' => 1, 'pageSize' => 75 }
    }

    def initialize(resource, options = {})
      @resource = resource
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def data
      @data || get
    end

    def get(query = {})
      self.options[:query].merge!(query)
      @data = response.parsed_response
    end

    def response
      @response = HTTParty.get(url, headers: { 'Accept' => 'application/json' }, query: self.options[:query])
    end

    def url
      url = "https://#{options[:company_id]}+#{options[:public_key]}:#{options[:private_key]}"
      url += "@#{options[:url_prefix]}"
      url += "/v4_6_release/apis/#{options[:api_version]}"
      url += resource

      return url
    end

    ### Pagination ###

    def next_page?
      self.data.is_a?(Array) && self.data.count == self.options[:query]['pageSize']
    end

    def next_page
      self.options[:query]['page'] += 1
      return get
    end

    def previous_page?
      self.options[:query]['page'] > 1
    end

    def previous_page
      self.options[:query]['page'] -= 1
      return get
    end

  end
end