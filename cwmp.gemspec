require './lib/cwmp/version'

Gem::Specification.new do |spec|
    spec.name         = 'cwmp'
    spec.version      = Cwmp::VERSION
    spec.date         = '2014-07-14'
    spec.summary      = "A CWMP library"
    spec.description  = "A ruby library to parse and generate CWMP messages. Includes a CPE simulator and a simple ACS server."
    spec.authors      = ["Luca Cervasio"]
    spec.email        = 'luca.cervasio@gmail.com'
    spec.files        = `git ls-files`.split($/)
    spec.executables  = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
    spec.homepage     = 'https://github.com/lucacervasio/ruby-cwmp'
    spec.license      = 'MIT'

    spec.add_dependency('nokogiri', '~> 1.6', '>= 1.6.0')
    spec.add_dependency('rack', '~> 1.5', '>= 1.5.2')
    spec.add_dependency('thin', '~> 1.6', '>= 1.6.2')
    spec.add_dependency('http_router', '~> 0.11', '>= 0.11.1')
    spec.add_dependency('httpclient', '~> 2.4', '>= 2.4.0')
end