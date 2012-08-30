class TestHTTPartyClient
  include HTTParty
  persistent_connection_adapter
end

class WebRequest
  include WebMock::API

  attr_accessor :uri, :verb, :content_type, :request_body, :response_body

  def initialize
    @uri = 'http://www.example.com/'
    @verb = :get
    @content_type = 'text/plain'
    @response_body = 'Hello!'
  end

  def verb=(arg)
    unless arg.is_a? Symbol
      @verb = arg.to_s.downcase.to_sym
    else
      @verb = arg
    end
  end

  VALID_VERBS = %w(get head post put delete patch options).collect { |v| v.to_sym }

  def mock
    stub_request(verb, uri).to_return(:body => response_body, :headers => {:content_type => content_type})
  end

  def perform
    case verb
    when :get
      TestHTTPartyClient.get(uri)
    else
      raise "#{verb} is not a supported HTTP verb"
    end
  end
end
