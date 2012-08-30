require 'spec_helper'

describe HTTParty::Persistent::ConnectionAdapter do
  let(:uri) { URI 'http://foo.com:8085' }
  let(:connection_adapter_options) { {} }
  let(:options) { {:connection_adapter_options => connection_adapter_options} }
  let(:adapter) { HTTParty::Persistent::ConnectionAdapter.new(uri, options) }
  subject { adapter }

  it { should be_kind_of(HTTParty::ConnectionAdapter) }

  describe "#connection" do
    describe "the resulting connection" do
      subject { adapter.connection }

      it { should be_instance_of PersistentHTTP }
      its(:host) { should == uri.host }
      its(:port) { should == uri.port }

      context "setting connection_adapter_options" do
        let(:connection_adapter_options) { {:name => 'spec_adapter'} }

        its(:name) { should == 'spec_adapter' }
      end

      #context "ssl" do
        #context "a non-ssl connection is used" do
          #let(:uri) { URI 'http://www.clear.com/' }

          #it "should not use ssl" do
            #subject.use_ssl.should be_false
          #end
        #end

        #context "an ssl connection is used" do
          #let(:uri) { URI 'https://www.secure.com/' }

          #it "should use ssl" do
            #subject.use_ssl.should be_true
          #end
        #end

        #context "an ssl connection with a non-standard port is used" do
          #let(:uri) { URI 'https://www.secure.com:208934/' }

          #it "should use ssl" do
            #subject.use_ssl.should be_true
          #end
        #end
      #end
    end
  end
end
