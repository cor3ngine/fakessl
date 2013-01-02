require 'socket'
require 'openssl'

module FakeSSL

  class << self; attr_accessor :domain, :cert, :key; end

  FakeSSL.domain = nil
  FakeSSL.cert = nil
  FakeSSL.key = nil

  def FakeSSL.cert_path(fcert, fkey)
    FakeSSL.cert = fcert
    FakeSSL.key = fkey
  end

  class Cert
    def initialize(domain)
      FakeSSL.domain = domain
    end

    public
      def generate
        %x[openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=#{FakeSSL.domain}" -keyout #{FakeSSL.domain}.key  -out #{FakeSSL.domain}.cert]
      end
  end

  class Server
    def initialize(lport)
      @lport = lport.to_i
      sslServer = server_setup
      puts "[+] Fake #{FakeSSL.domain} is listening on port #{@lport}"
      get_request(sslServer)
    end

    private
      def server_setup
        server = TCPServer.new('localhost', @lport)
        sslContext = OpenSSL::SSL::SSLContext.new
        #certificate
        if FakeSSL.cert.nil?
          sslContext.cert = OpenSSL::X509::Certificate.new(File.open("#{FakeSSL.domain}.cert"))
        else
          sslContext.cert = OpenSSL::X509::Certificate.new(File.open("#{FakeSSL.cert}"))
        end
        #private key
        if FakeSSL.key.nil?
          sslContext.key = OpenSSL::PKey::RSA.new(File.open("#{FakeSSL.domain}.key"))
        else
          sslContext.key = OpenSSL::PKey::RSA.new(File.open("#{FakeSSL.key}"))
        end
        sslServer = OpenSSL::SSL::SSLServer.new(server,sslContext)
        return sslServer
      end

      def get_request(sslServer)
        puts "[+] Client requests are: "
        loop do
          conn = sslServer.accept
          lineIn = conn.gets
          if !lineIn.nil?
            puts "=> " + lineIn
          end
        end
      end
  end

end

