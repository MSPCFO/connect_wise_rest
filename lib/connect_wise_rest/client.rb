module ConnectWiseRest
  class Client

    attr_reader :options

    DEFAULT_OPTIONS = {
        company_id: ConnectWiseRest.configuration.company_id,
        public_key: ConnectWiseRest.configuration.public_key,
        private_key: ConnectWiseRest.configuration.private_key,
        url_prefix: ConnectWiseRest.configuration.url_prefix,
        version: ConnectWiseRest.configuration.version
    }

    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def get(resource)
      HTTParty.get(url(resource), headers: { 'Accept' => 'application/json' }).parsed_response
    end

    def url(resource)
      url = "https://#{options[:company_id]}+#{options[:public_key]}:#{options[:private_key]}"
      url += "@#{options[:url_prefix]}"
      url += "/v4_6_release/apis/#{options[:api_version]}"
      url += resource

      return url
    end

  end
end