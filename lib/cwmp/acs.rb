require 'rubygems'
require 'rack'
require 'thin'
require 'http_router'
require 'nokogiri'
require 'readline'
require 'digest'
require 'singleton'

Thread::abort_on_exception = true

module Cwmp

    class CpeSession
        def initialize

        end
    end

    class Request
        attr_accessor :message, :cb
        def initialize message, &block
            @message = message
            @cb = block
        end
    end

    class AcsCpe
        attr_accessor :serial, :conn_req, :queue, :session_cookie, :req_currently_in_service, :session

        def initialize serial
            @serial = serial
            @queue = Queue.new
            @req_currently_in_service = nil
            @session = nil
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

            begin
                if len == 0
                    message_type = ''
                else
                    body = req.body.read
                    mess = Cwmp::Message::parse_from_text body
                    message_type = mess.message_type
                end

                if message_type == "Inform"
                    doc = mess.parsed_xml_doc
                    manufacturer = doc.css("Manufacturer").text
                    oui = doc.css("OUI").text
                    serial_number = doc.css("SerialNumber").text
                    event_codes = doc.css("EventCode").map { |n| n.text }
                    parameters = {}
                    doc.css("ParameterValueStruct").map { |it| parameters[it.element_children[0].text] = it.element_children[1].text }

                    ck = Digest::MD5.hexdigest("#{serial_number}#{Time.new.to_i}")

                    if !@acs.cpes.has_key? serial_number
                        cpe = AcsCpe.new serial_number
                        cpe.conn_req = parameters['InternetGatewayDevice.ManagementServer.ConnectionRequestURL']
                        cpe.session_cookie = ck
                        @acs.cpes[serial_number] = cpe
                    end
                    puts "got Inform from #{req.ip}:#{req.port} [sn #{serial_number}] with eventcodes #{event_codes.join(", ")}"

                    inform_response = Cwmp::Message::InformResponse.build
                    response = Rack::Response.new inform_response.xml, 200, {'Connection' => 'Keep-Alive', 'Server' => 'ruby-cwmp'}
                    response.set_cookie("sessiontrack", {:value => ck, :path => "/", :expires => Time.now+24*60*60})
                    response.finish
                elsif message_type == "TransferComplete"
                    puts "got TransferComplete"
                else
                    cookie = req.cookies['sessiontrack']
                    @acs.cpes.each do |k,c|
                        cpe = c if c.session_cookie = cookie
                    end

                    if len == 0
                        puts "got Empty Post"
                    else
                        puts "got #{message_type}"
                        doc = mess.parsed_xml_doc
                        case message_type
                            when "GetParameterValuesResponse"
                                doc.css("ParameterValueStruct").each do |node|
                                    puts "#{node.element_children[0].text}: #{node.element_children[1].text}"
                                end
                            when "Fault"
                                puts "#{doc.css("faultstring").text}: #{doc.css("FaultString").text}"
                        end

                        if cpe.req_currently_in_service != nil
                            cpe.req_currently_in_service.cb.call(mess)
                        end
                    end


                    # Got Empty Post or a Response. Now check for any event to send, otherwise 204
                    if cpe.queue.size > 0
                        m = cpe.queue.pop
                        cpe.req_currently_in_service = m
                        response = Rack::Response.new m.message, 200, {'Connection' => 'Keep-Alive', 'Server' => 'ruby-cwmp'}
                        response.finish
                    else
                        puts "sending 204"
                        [204, {"Connection" => "Close", 'Server' => 'ruby-cwmp'}, ""]
                    end
                end
            rescue Exception => e
                puts e
                puts e.backtrace
                raise e
            end
        end

    end


    class Acs
        include Singleton

        attr_accessor :cpes

        def initialize
            ac = self

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
                'help', 'list', 'quit', "waitMessage"
            ].sort

            comp = proc { |s| list.grep(/^#{Regexp.escape(s)}/) }

            ::Readline.completion_append_character = " "
            ::Readline.completion_proc = comp

            while line = ::Readline.readline('> ', true)
                case line
                    when "quit", "exit"
                        puts "Bye"
                        exit(0)
                    when "help"
                        puts "help not available"
                    when "list games"
                        puts ["FALKEN'S MAZE", "BLACK JACK", "GIN RUMMY", "HEARTS", "BRIDGE", "CHECKERS", "CHESS", "POKER", "FIGHTER COMBAT", "GUERRILLA ENGAGEMENT", "DESERT WARFARE" "AIR-TO-GROUND ACTIONS", "THEATERWIDE TACTICAL WARFARE", "THEATERWIDE BIOTOXIC AND CHEMICAL WARFARE", "GLOBAL THERMONUCLEAR WAR"].join "\n"
                    when "help games"
                        puts "Games refers to models, simulations and games which have strategic applications"
                    when "list"
                        p @cpes
                    when /send (\w+) (\w+) (.+)/
                        message_type = $1
                        serial = $2
                        args = $3.split(" ")

                        allowed_messages = ["GetParameterValues", "GetParameterNames", "SetParameterValues", "AddObject", "DeleteObject", "Reboot", "FactoryReset"]
                        if !allowed_messages.include? message_type
                            puts "cmd #{message_type} unknown"
                            next
                        end

                        cpe = @cpes[serial]
                        if !cpe
                            puts "cpe #{serial} unknown"
                            next
                        end

                        mess = Object.const_get("Cwmp").const_get("Message").const_get(message_type).build args
                        puts mess
                        cpe.queue << Cwmp::Request.new(mess) do |resp|
                            puts "arrived #{resp}"
                        end
                        cpe.do_connection_request
                    when "run"
                        begin
                            require './examples/api_usage'
                        rescue LoadError
                            puts "file not found"
                        rescue SyntaxError => e
                            puts "file contains syntax errors: #{e.message}"
                        rescue Exception => e
                            puts "runtime error: #{e.message}"
                        end
                    else
                        puts "unknown command <#{line}>" if line != ""
                end
            end
        end

        def start port
            trap("SIGINT") { puts "Bye"; exit! }
            @port = port
            puts "ACS #{Cwmp::VERSION} by Luca Cervasio <luca.cervasio@gmail.com>"
            puts "Daemon running on http://localhost:#{@port}/acs"

            Thread.new do
                start_cli
            end

            Thin::Logging.silent = true
            Rack::Handler::Thin.run @app, :Port => @port

        end

        def start_session(serial, &block)

        end

    end

end