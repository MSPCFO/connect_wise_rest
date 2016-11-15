module ConnectWiseRest

  class << self
    attr_accessor :config
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield(config)
  end

  class Configuration
    attr_accessor :company_id, :private_key, :public_key, :url_prefix, :version, :debug

    def initialize
      @version = '3.0'
      @debug = false
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