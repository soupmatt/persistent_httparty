require 'persistent_http'

module HTTParty::Persistent
  class ConnectionAdapter

    attr_accessor :persistent_http

    def call(uri, options)
      @persistent_http ||= build_persistent_http(uri, options)
    end

    def build_persistent_http(uri, options)
      opts = {:url => uri}
      opts.merge!(options[:connection_adapter_options]) if options[:connection_adapter_options]
      if options[:timeout] && (options[:timeout].is_a?(Integer) || options[:timeout].is_a?(Float))
        opts.merge!(:read_timeout => options[:timeout], :open_timeout => options[:timeout])
      end
      opts.merge!(:debug_output => options[:debug_output]) if options[:debug_output]

      if options[:http_proxyaddr]
        proxy_opts = {:host => options[:http_proxyaddr]}
        proxy_opts[:port] = options[:http_proxyport] if options[:http_proxyport]
        opts[:proxy] = URI::HTTP.build(proxy_opts)
        opts[:proxy].user = options[:http_proxyuser] if options[:http_proxyuser]
        opts[:proxy].password = options[:http_proxypass] if options[:http_proxypass]
      end

      PersistentHTTP.new(opts)
    end
  end
end
