require 'thread' if RUBY_VERSION < '1.9' # hack fix for ruby 1.8 until https://github.com/bpardee/gene_pool/pull/1 is merged
require 'persistent_http'

module HTTParty::Persistent
  class ConnectionAdapter < HTTParty::ConnectionAdapter

    def connection
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
