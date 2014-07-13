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

    s.add_dependency('nokogiri')
    s.add_dependency('rack')
    s.add_dependency('thin')
    s.add_dependency('http_router')
    s.add_dependency('eventmachine')
    s.add_dependency('faye-websocket')
end