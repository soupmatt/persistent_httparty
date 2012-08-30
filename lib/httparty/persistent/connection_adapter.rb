require 'persistent_http'

module HTTParty::Persistent
  class ConnectionAdapter < HTTParty::ConnectionAdapter

    def connection
      opts = {:url => uri}
      opts.merge!(options[:connection_adapter_options]) if options[:connection_adapter_options]
      PersistentHTTP.new(opts)
    end
  end
end
