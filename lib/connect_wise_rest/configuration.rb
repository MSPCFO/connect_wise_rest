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
    attr_accessor :company_id, :private_key, :public_key, :url_prefix, :version, :code

    def initialize
      @version = '3.0'
      @code = 'v4_6_release'
    end

    def set(options = {})
      options.each { |k, v| self.send("#{k.to_s}=", v) }
    end

  end

end