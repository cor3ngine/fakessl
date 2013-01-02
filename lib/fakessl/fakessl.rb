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
        puts "[+] Generating fake key and certificate for #{FakeSSL.domain}"
        #generate keys
        key = OpenSSL::PKey::RSA.new 4096
        open "#{FakeSSL.domain}.key", 'w' do |io| io.write key.to_pem end

        #generate certificate 
        name = OpenSSL::X509::Name.parse "CN=#{FakeSSL.domain}/DC=server"
        cert = OpenSSL::X509::Certificate.new
        cert.version = 2
        cert.serial = 0
        cert.not_before = Time.now
        cert.not_after = Time.now +  ( 3600 * 24 * 365 )
        cert.public_key = key.public_key
        cert.subject = name

        #selfsign certificate
        cert.issuer = name
        cert.sign key, OpenSSL::Digest::SHA1.new
        open "#{FakeSSL.domain}.cert", 'w' do |io| io.write cert.to_pem end
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

