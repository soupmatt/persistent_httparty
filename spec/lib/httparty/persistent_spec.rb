require 'spec_helper'

describe HTTParty::Persistent do
  let!(:klass) { Class.new }
  before(:each) do
    klass.instance_eval { include HTTParty }
  end

  describe HTTParty do
    it "includes HTTParty::Persistent" do
      HTTParty::ClassMethods.should include_module(HTTParty::Persistent::ClassMethods)
    end

    context "across multiple requests" do
      let(:base_uri) { URI 'http://example.com' }

      it "reuses the same http connection" do
        http = Net::HTTP.new(base_uri.host, base_uri.port)
        Net::HTTP.should_receive(:new).once().and_return(http)

        stub_request(:get, "#{base_uri.to_s}/status").
          to_return(:status => 200, :body => "", :headers => {})

        stub_request(:get, "#{base_uri.to_s}/info").
          to_return(:status => 200, :body => "", :headers => {})

        klass.base_uri base_uri.to_s
        klass.persistent_connection_adapter

        klass.get('/status')
        klass.get('/info')
      end
    end
  end

  describe "#persistent_connection_adapter" do
    before(:each) { klass.persistent_connection_adapter }

    it "sets the connection_adapter to HTTParty::Persistent::ConnectionAdapter" do
      klass.connection_adapter.should be_a HTTParty::Persistent::ConnectionAdapter
    end

    context "with connection_adapter_options" do
      let(:connection_adapter_options) { {:foo => :bar} }
      before(:each) { klass.persistent_connection_adapter(connection_adapter_options) }

      it "sets the connection_adapter_options that are passed to it" do
        klass.default_options[:connection_adapter_options].should == connection_adapter_options
      end
    end
  end
end
