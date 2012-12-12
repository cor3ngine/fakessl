require 'socket'
require 'openssl'

class FakeSSL 

  def initialize(hostname,lport)
    @hostname = hostname
    @lport = lport.to_i
    $stdout.puts "[+] Generating fake SSL certificate for #{@hostname}"
    generate_certificate
    sslServer = server_setup
    $stdout.puts "[+] Fake #{@hostname} is listening on port #{@lport}"
    get_request(sslServer)
  end

  def generate_certificate
    %x[openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=#{@hostname}" -keyout #{@hostname}.key  -out #{@hostname}.cert]
  end

  def server_setup
    server = TCPServer.new('localhost', @lport)
    sslContext = OpenSSL::SSL::SSLContext.new
    #certificate
    sslContext.cert = OpenSSL::X509::Certificate.new(File.open("#{@hostname}.cert"))
    #private key
    sslContext.key = OpenSSL::PKey::RSA.new(File.open("#{@hostname}.key"))
    sslServer = OpenSSL::SSL::SSLServer.new(server,sslContext)
    return sslServer
  end

  def get_request(sslServer)
    $stdout.puts "[+] Client requests are: "
    loop do
      conn = sslServer.accept
      lineIn = conn.gets
      if !lineIn.nil?
        $stdout.puts "=> " + lineIn
      end
    end
  end

  private :generate_certificate, :server_setup, :get_request

end

