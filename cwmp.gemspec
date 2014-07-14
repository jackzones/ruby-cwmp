require './lib/cwmp/version'

Gem::Specification.new do |s|
    s.name        = 'cwmp'
    s.version     = Cwmp::VERSION
    s.date        = '2014-07-14'
    s.summary     = "A CWMP library"
    s.description = "A ruby library to parse and generate CWMP messages. Includes a CPE simulator and a simple ACS server."
    s.authors     = ["Luca Cervasio"]
    s.email       = 'luca.cervasio@gmail.com'
    s.files       = `git ls-files`.split($/)
    s.homepage    = 'https://github.com/lucacervasio/ruby-cwmp'
    s.license     = 'MIT'

    s.add_dependency('nokogiri', '~> 1.6', '>= 1.6.0')
    s.add_dependency('rack', '~> 1.5', '>= 1.5.2')
    s.add_dependency('thin', '~> 1.6', '>= 1.6.2')
    s.add_dependency('http_router', '~> 0.11', '>= 0.11.1')
    s.add_dependency('eventmachine', '~> 1.0', '>= 1.0.3')
    s.add_dependency('faye-websocket', '~> 0.6', '>= 0.6.2')
    s.add_dependency('httpclient', '~> 2.4', '>= 2.4.0')
end