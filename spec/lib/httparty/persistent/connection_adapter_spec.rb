require 'spec_helper'

describe HTTParty::Persistent::ConnectionAdapter do
  let(:uri) { URI 'http://foo.com:8085' }
  let(:connection_adapter_options) { {} }
  let(:options) { {:connection_adapter_options => connection_adapter_options} }
  let!(:adapter) { HTTParty::Persistent::ConnectionAdapter.new }
  subject { adapter }

  describe "#call" do
    subject { adapter.call(uri, options) }

    it "returns a PersistentHTTP" do
      subject.should be_a PersistentHTTP
    end

    it "returns the same PersistentHTTP across calls" do
      adapter.call(uri, options).should be subject
    end

    describe "the resulting PersistentHTTP" do
      subject { adapter.call(uri, options) }

      it { should_not be_nil }
      it { should be_instance_of PersistentHTTP }
      its(:host) { should == uri.host }
      its(:port) { should == uri.port }

      it "is the same across multiple calls" do
        adapter.call(uri, options).should be subject
        adapter.call(uri, options).should be subject
      end

      context "when dealing with ssl" do
        Spec::Matchers.define :use_ssl do
          match do |connection|
            connection.use_ssl
          end
        end

        context "using port 443 for ssl" do
          let(:uri) { URI 'https://api.foo.com/v1:443' }
          it { should use_ssl }
        end

        context "using port 80" do
          let(:uri) { URI 'http://foobar.com' }
          it { should_not use_ssl }
        end

        context "https scheme with default port" do
          let(:uri) { URI 'https://foobar.com' }
          it { should use_ssl }
        end

        context "https scheme with non-standard port" do
          let(:uri) { URI 'https://foobar.com:123456' }
          it { should use_ssl }
        end
      end

      context "when setting timeout" do
        context "to 5 seconds" do
          let(:options) { {:timeout => 5} }

          its(:open_timeout) { should == 5 }
          its(:read_timeout) { should == 5 }
        end

        context "and timeout is a string" do
          let(:options) { {:timeout => "five seconds"} }

          it "doesn't set the timeout" do
            subject.open_timeout.should be_nil
            subject.read_timeout.should be_nil
          end
        end
      end

      context "when debug_output" do
        context "is set to $stderr" do
          let(:options) { {:debug_output => $stderr} }
          it "has debug output set" do
            subject.debug_output.should == $stderr
          end
        end

        context "is not provided" do
          let(:options) { {} }
          it "does not set_debug_output" do
            subject.debug_output.should be_nil
          end
        end
      end

      context 'when providing proxy address and port' do
        let(:options) { {:http_proxyaddr => '1.2.3.4', :http_proxyport => 8080} }

        its(:proxy_uri) { should == URI.parse('http://1.2.3.4:8080') }

        context 'as well as proxy user and password' do
          let(:options) do
            {:http_proxyaddr => '1.2.3.4', :http_proxyport => 8080,
             :http_proxyuser => 'user', :http_proxypass => 'pass'}
          end
          its(:proxy_uri) do
            uri = URI.parse('http://1.2.3.4:8080')
            uri.user = 'user'
            uri.password = 'pass'
            should == uri
          end
        end
      end

      context "when providing PEM certificates", :pending => true do
        let(:pem) { :pem_contents }
        let(:options) { {:pem => pem, :pem_password => "password"} }

        context "when scheme is https" do
          let(:uri) { URI 'https://google.com' }
          let(:cert) { mock("OpenSSL::X509::Certificate") }
          let(:key) { mock("OpenSSL::PKey::RSA") }

          before do
            OpenSSL::X509::Certificate.should_receive(:new).with(pem).and_return(cert)
            OpenSSL::PKey::RSA.should_receive(:new).with(pem, "password").and_return(key)
          end

          it "uses the provided PEM certificate " do
            subject.cert.should == cert
            subject.key.should == key
          end

          it "will verify the certificate" do
            subject.verify_mode.should == OpenSSL::SSL::VERIFY_PEER
          end
        end

        context "when scheme is not https" do
          let(:uri) { URI 'http://google.com' }
          let(:http) { Net::HTTP.new(uri) }

          before do
            Net::HTTP.stub(:new => http)
            OpenSSL::X509::Certificate.should_not_receive(:new).with(pem)
            OpenSSL::PKey::RSA.should_not_receive(:new).with(pem, "password")
            http.should_not_receive(:cert=)
            http.should_not_receive(:key=)
          end

          it "has no PEM certificate " do
            subject.cert.should be_nil
            subject.key.should be_nil
          end
        end
      end
    end
  end
end
