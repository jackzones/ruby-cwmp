require 'rubygems'
require 'rack'
require 'thin'
require 'http_router'
require 'nokogiri'
require 'readline'

Thread::abort_on_exception = true

module Cwmp

    class AcsCpe
        attr_accessor :serial, :conn_req, :queue, :session_cookie

        def initialize serial
            @serial = serial
            @queue = Queue.new
        end

        def do_connection_request
            c = HTTPClient.new
            c.get @conn_req
        end

    end

    class Handler
        def initialize obj
            @acs = obj
        end

        def call(env)
            req = Rack::Request.new(env)
            len = req.content_length.to_i
            cookie = req.cookies['sessiontrack']

            if len == 0
                message_type = ''
            else
                doc = Nokogiri::XML(req.body.read)
                message_type = doc.css("soap|Body")[0].element_children[0].name
            end

            if message_type == "Inform"
                manufacturer = doc.css("Manufacturer").text
                oui = doc.css("OUI").text
                serial_number = doc.css("SerialNumber").text
                event_codes = doc.css("EventCode").map { |n| n.text }
                parameters = {}
                doc.css("ParameterValueStruct").map { |it| parameters[it.children[1].text] = it.children[3].text }

                ck = "sdfd"

                if !@acs.cpes.has_key? serial_number
                    cpe = AcsCpe.new serial_number
                    cpe.conn_req = parameters['InternetGatewayDevice.ManagementServer.ConnectionRequestURL']
                    cpe.session_cookie = ck
                    @acs.cpes[serial_number] = cpe
                end
                puts "got Inform from #{req.ip}:#{req.port} [sn #{serial_number}] with eventcodes #{event_codes.join(", ")}"

                inform_response = Cwmp::Message::inform_response
                response = Rack::Response.new inform_response, 200, {'Connection' => 'Keep-Alive', 'Server' => 'ruby-cwmp'}
                response.set_cookie("sessiontrack", {:value => "294823094lskdfsfsdf", :path => "/", :expires => Time.now+24*60*60})
                response.finish
            elsif message_type == "TransferComplete"
                puts "got TransferComplete"
            else
                if message_type.include? "Response"
                    puts "got #{message_type}"
                elsif len == 0
                    puts "got Empty Post"
                end

                # Got Empty Post or a Response. Now check for any event to send, otherwise 204
                # if @acs.cpes['A54FD'].queue.size > 0
                #     m = @acs.cpes['A54FD'].queue.pop
                #     response = Rack::Response.new m, 200, {'Connection' => 'Keep-Alive', 'Server' => 'ruby-cwmp'}
                #     response.finish
                # else
                    [204, {"Connection" => "Close", 'Server' => 'ruby-cwmp'}, ""]
                # end

            end
        end

    end


    class Acs
        attr_accessor :cpes

        def initialize (port)
            ac = self
            @port = port
            # @handler = Handler.new
            @app = HttpRouter.new do
                # add('/api').to(SocketApp.new)
                add('/acs').to(Handler.new(ac))
            end
            @cpes = {}
        end

        def start_cli
            list = [
                'GetParameterValues', 'SetParameterValues', 'Reboot', 'FactoryReset', 'Download', 'AddObject', 'DeleteObject',
                'help', 'quit', "waitMessage"
            ].sort

            comp = proc { |s| list.grep(/^#{Regexp.escape(s)}/) }

            ::Readline.completion_append_character = " "
            ::Readline.completion_proc = comp

            while line = ::Readline.readline('> ', true)
                case line
                    when "quit"
                        puts "Bye"
                        exit(0)
                    when "help"
                        help
                    when "list"
                        p @cpes
                    when /^get (\w+) (.+)/
                        puts "getting #{$1} #{$2}"
                        cpe = @cpes[$1]
                        cpe.queue << Cwmp::Message::get_parameter_values($2)
                        cpe.do_connection_request
                end
            end
        end

        def start
            puts "ACS #{Cwmp::VERSION} by Luca Cervasio <luca.cervasio@gmail.com>"
            puts "Daemon running on http://localhost:#{@port}/acs"
            @web = Thread.new do
                # Thin::Logging.silent = true
                Rack::Handler::Thin.run @app, :Port => @port
            end

            start_cli
        end
    end

end