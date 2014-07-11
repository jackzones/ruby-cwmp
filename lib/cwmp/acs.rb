#!/env ruby

require 'rubygems'
require 'rack'
require 'thin'
require 'http_router'
require 'rack/websocket'
require 'nokogiri'


module Cwmp

    VERSION = "0.1.2"

    class SocketApp < Rack::WebSocket::Application
        def on_open(env)
            puts 'Client connected'
        end

        def on_close(env)
            puts 'Client disconnected'
        end

        def on_message(env, message)
            case message
                when "list"
                    puts "list"
                    send_data 'ok man'
                else
                    puts "Got message: #{message}"
                    send_data 'Here is your reply'
            end
        end
    end


    class WebApp

        def call(env)
            req = Rack::Request.new(env)
            len = req.content_length.to_i

            if len == 0
                message_type = ''
            else
                doc = Nokogiri::XML(req.body.read)
                message_type = doc.css("soap|Body").children.map(&:name)[1]
            end

            if message_type == "Inform"
                manufacturer = doc.css("Manufacturer").text
                oui = doc.css("OUI").text
                serial_number = doc.css("SerialNumber").text
                event_codes = doc.css("EventCode").map { |n| n.text }
                parameters = {}
                doc.css("ParameterValueStruct").map { |it| parameters[it.children[1].text] = it.children[3].text }

                puts "got Inform from #{req.ip}:#{req.port} [sn #{serial_number}] with eventcodes #{event_codes.join(", ")}"

                inform_response = Moses::Message::inform_response
                response = Rack::Response.new inform_response, 200, {'Connection' => 'Keep-Alive', 'Server' => 'Moses'}
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
                [204, {"Connection" => "Close", 'Server' => 'Moses'}, ""]
            end
        end

    end


    class Acs
        def initialize (port)
            @port = port
            @app = HttpRouter.new do
                add('/api').to(SocketApp.new)
                add('/acs').to(WebApp.new)
            end
        end

        def start
            Thin::Logging.silent = true
            Rack::Handler::Thin.run @app, :Port => @port
        end
    end


end