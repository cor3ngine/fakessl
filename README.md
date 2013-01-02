# FakeSSL

FakeSSL impersonates an HTTPS server and prints the client requests.

## Installation

Download and unzip the master zip from github and execute the following into fakessl dir

    $ gem build ./fakessl.gemspec
    $ gem install fakessl-0.0.3.gem
 
Or install it as:

    $ gem install fakessl

## Usage

Generate a certificate:

    $ fakessl -g test.org
      [+] Generating fake key and certificate for test.org

Use the previous certificate and key to setup a fake HTTPS server on port 443:

    $ sudo fakessl -c test.org.cert -k test.org.key -p 443
      Password:
      [+] Fake test.org is listening on port 443
      [+] Client requests are: 
      => GET /advv HTTP/1.1

Single command line to generate certificate and key and setup the HTTPS server:
    
    $ sudo fakessl -g test.org -p 443
      Password:
      [+] Generating fake key and certificate for test.org
      [+] Fake test.org is listening on port 443
      [+] Client requests are: 
      => GET /byy.html HTTP/1.1

In case you need to use it with a browser that checks the authenticity 
of the certificate you need to import the generated certificate as trusted.
Firefox example.
Go to Edit -> Preferences -> Advanced -> View Certificates -> Servers -> Import 
-> Choose the certificate from your drive after generating it.
Then select the imported certificate and click on the button "Edit Trust...". 
Inside the Firefox window enable "Trust the authenticity of this certificate"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
