module ConnectWiseRest

  class << self
    attr_accessor :client
  end

  def self.client
    @client ||= Client.new
  end

  class Client

    attr_reader :config

    def initialize
      @config = ConnectWiseRest.config
      yield @config if block_given?
    end

  end
end