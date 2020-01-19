module ConnectWiseRest
  class Client

    attr_accessor :options
    attr_reader :resource

    DEFAULT_OPTIONS = ConnectWiseRest.configuration.to_hash.merge(
      {
        headers: {},
        query: { 'page' => 1, 'pageSize' => 75 },
        timeout: 300,
        request_options: {}
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

      raise_error(response) unless response.success?

      @data = response.parsed_response
    end

    def response
      @response ||= HTTParty.get(url, request_options)
    rescue StandardError => e
      raise ConnectionError.new(e.message)
    end

    def request_options
      request_options = options[:request_options] || {}

      request_options.merge!(
        headers: { 'Accept' => 'application/json' }.merge(options[:headers]),
        query: self.options[:query],
        timeout: options[:timeout],
        basic_auth: {
          username: "#{options[:company_id]}+#{options[:public_key]}",
          password: options[:private_key]
        }
      )

      if options[:proxy_host]
        request_options.merge!(
          http_proxyaddr: options[:proxy_host],
          http_proxyport: options[:proxy_port],
          http_proxyuser: options[:proxy_user],
          http_proxypass: options[:proxy_password],
        )
      end

      if options[:debug] && options[:logger]
        request_options[:debug_output] = options[:logger]
      end

      request_options
    end

    def url
      "https://#{options[:url_prefix]}/v4_6_release/apis/#{options[:version]}#{resource}"
    end

    ### Pagination ###

    def next_page?
      self.data.is_a?(Array) && self.data.count >= self.options[:query]['pageSize']
    end

    def next_page
      self.options[:query]['page'] += 1
      self.options[:query]['pageId'] = page_id

      return fetch
    end

    def previous_page?
      self.options[:query]['page'] > 1
    end

    def previous_page
      self.options[:query]['page'] -= 1
      return fetch
    end

    def page_id
      pp response.headers
      url = URI.parse(response.headers['Link'])
      params = CGI.parse(url.query)
      params['pageId']
    end

    private

      def raise_error(response)
        msg = if response.parsed_response
                "#{response.parsed_response['code']}: #{response.parsed_response['message']}"
              else
                response.body
              end

        raise ConnectionError.new(msg)
      end
  end
end