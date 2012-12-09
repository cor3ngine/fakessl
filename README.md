# FakeSSL

FakeSSL impersonates an HTTPS server and prints the client requests.

## Installation

Download and unzip the master zip from github and execute the following into fakessl dir

    $ gem build ./fakessl.gemspec
    $ gem install fakessl-0.0.1.gem
 
Or install it as:

    $ gem install fakessl

## Usage

    $ sudo fakessl -s localhost -p 443
      Password:
      [+] Generating fake SSL certificate for localhost
      Generating a 4096 bit RSA private key
      ........++
      ................................................................++
      writing new private key to 'localhost.key'
      -----
      [+] Fake localhost is listening on port 443
      [+] Client requests are: 
      => GET /byy.html HTTP/1.1


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
