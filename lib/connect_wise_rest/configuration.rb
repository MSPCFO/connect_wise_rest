module ConnectWiseRest

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :company_id, :private_key, :public_key, :url_prefix, :version, :debug, :logger,
                  :proxy_host, :proxy_port, :proxy_user, :proxy_password

    def initialize
      @version = '3.0'
      @debug = false
      @logger = $stdout
    end

    def set(options = {})
      options.each { |k, v| self.send("#{k.to_s}=", v) }
    end

    def to_hash
      hash = {}
      instance_variables.each { |var| hash[var.to_s.delete('@').to_sym] = instance_variable_get(var) }
      hash
    end
  end
end
