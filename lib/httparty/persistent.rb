require 'httparty'

module HTTParty::Persistent
  module ClassMethods
    def persistent_connection_adapter(opts={})
      connection_adapter HTTParty::Persistent::ConnectionAdapter, opts
    end
  end
end

HTTParty::ClassMethods.module_exec do
  include HTTParty::Persistent::ClassMethods
end

require 'httparty/persistent/connection_adapter'
