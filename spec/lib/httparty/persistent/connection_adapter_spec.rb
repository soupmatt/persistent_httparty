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
      is_expected.to be_a PersistentHTTP
    end

    it "returns the same PersistentHTTP across calls" do
      expect(adapter.call(uri, options)).to be subject
    end

    describe "the resulting PersistentHTTP" do
      subject { adapter.call(uri, options) }

      it { is_expected.to_not be_nil }
      it { is_expected.to be_instance_of PersistentHTTP }
      its(:host) { is_expected.to eq uri.host }
      its(:port) { is_expected.to eq uri.port }

      it "is the same across multiple calls" do
        expect(adapter.call(uri, options)).to be subject
        expect(adapter.call(uri, options)).to be subject
      end

      context "when dealing with ssl" do
        RSpec::Matchers.define :use_ssl do
          match do |connection|
            connection.use_ssl
          end
        end

        context "using port 443 for ssl" do
          let(:uri) { URI 'https://api.foo.com/v1:443' }
          it { is_expected.to use_ssl }
        end

        context "using port 80" do
          let(:uri) { URI 'http://foobar.com' }
          it { is_expected.not_to use_ssl }
        end

        context "https scheme with default port" do
          let(:uri) { URI 'https://foobar.com' }
          it { is_expected.to use_ssl }
        end

        context "https scheme with non-standard port" do
          let(:uri) { URI 'https://foobar.com:123456' }
          it { is_expected.to use_ssl }
        end
      end

      context "when setting timeout" do
        context "to 5 seconds" do
          let(:options) { {:timeout => 5} }

          its(:open_timeout) { is_expected.to eq 5 }
          its(:read_timeout) { is_expected.to eq 5 }
        end

        context "and timeout is a string" do
          let(:options) { {:timeout => "five seconds"} }

          it "doesn't set the timeout" do
            expect(subject.open_timeout).to be_nil
            expect(subject.read_timeout).to be_nil
          end
        end
      end

      context "when debug_output" do
        context "is set to $stderr" do
          let(:options) { {:debug_output => $stderr} }
          it "has debug output set" do
            expect(subject.debug_output).to eq $stderr
          end
        end

        context "is not provided" do
          let(:options) { {} }
          it "does not set_debug_output" do
            expect(subject.debug_output).to be_nil
          end
        end
      end

      context 'when providing proxy address and port' do
        let(:options) { {:http_proxyaddr => '1.2.3.4', :http_proxyport => 8080} }

        its(:proxy_uri) { is_expected.to eq URI.parse('http://1.2.3.4:8080') }

        context 'as well as proxy user and password' do
          let(:options) do
            {:http_proxyaddr => '1.2.3.4', :http_proxyport => 8080,
             :http_proxyuser => 'user', :http_proxypass => 'pass'}
          end
          its(:proxy_uri) do
            uri = URI.parse('http://1.2.3.4:8080')
            uri.user = 'user'
            uri.password = 'pass'
            is_expected.to eq uri
          end
        end
      end

      context "when providing PEM certificates", :pending => true do
        let(:pem) { :pem_contents }
        let(:options) { {:pem => pem, :pem_password => "password"} }

        context "when scheme is https" do
          let(:uri) { URI 'https://google.com' }
          let(:cert) { instance_double(OpenSSL::X509::Certificate) }
          let(:key) { instance_double(OpenSSL::PKey::RSA) }

          before do
            expect(OpenSSL::X509::Certificate).to receive(:new).with(pem).and_return(cert)
            expect(OpenSSL::PKey::RSA).to receive(:new).with(pem, "password").and_return(key)
          end

          it "uses the provided PEM certificate " do
            expect(subject.cert).to eq cert
            expect(subject.key).to eq key
          end

          it "will verify the certificate" do
            expect(subject.verify_mode).to eq OpenSSL::SSL::VERIFY_PEER
          end
        end

        context "when scheme is not https" do
          let(:uri) { URI 'http://google.com' }
          let(:http) { Net::HTTP.new(uri) }

          before do
            allow(Net::HTTP).to receive(:new).and_return(http)
            expect(OpenSSL::X509::Certificate).to_not receive(:new).with(pem)
            expect(OpenSSL::PKey::RSA).to_not receive(:new).with(pem, "password")
            expect(http).to receive(:cert=)
            expect(http).to receive(:key=)
          end

          it "has no PEM certificate " do
            expect(subject.cert).to be_nil
            expect(subject.key).to be_nil
          end
        end
      end
    end
  end
end
