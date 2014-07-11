require 'httpclient'

module Cwmp

    class Cpe

        attr_accessor :serial, :oui, :software_version, :manufacturer, :acs_url, :state

        def initialize (acs_url, h = {})
            @acs_url = acs_url
            @serial = h[:serial] || "23434ds"
            @oui = h[:oui] || "0013C8"
            @software_version = h[:software_version] || "0.1.1"
            @manufacturer = h[:manufacturer] || "Moonar"
            @state = 'off'
            @t = Thread.new { periodic 10 }
            @t = Thread.new { connection_request }
        end

        def poweron
            @state = 'on'
            do_connection '0 BOOTSTRAP'
        end

        def poweroff
            @state = 'off'
        end

        def reboot
            @state = 'off'
            sleep 2
            @state = 'on'
            do_connection '1 BOOT'
        end

        def reset
            do_connection '0 BOOTSTRAP'
        end

        private

        def periodic time
            while true
                sleep time
                do_connection '2 PERIODIC'
            end
        end

        def connection_request

        end

        def do_connection(event)
            c = HTTPClient.new

            resp = c.post @acs_url, Cwmp::Message::inform(@manufacturer, @oui, @serial, event, @software_version)
            doc = Nokogiri::XML(resp.body)
            message_type = doc.css("soap|Body").children.map(&:name)[1]
            puts "got #{message_type} message"

            resp = c.post @acs_url, ""
            while resp.status != 204
                doc = Nokogiri::XML(resp.body)
                message_type = doc.css("soap|Body").children.map(&:name)[1]
                case message_type
                    when "GetParameterValues"
                        puts "got #{message_type}"
                        resp = c.post @acs_url, Cwmp::Message::get_parameter_values_response
                    when "GetParameterNames"
                        puts "got #{message_type}"
                        resp = c.post @acs_url, Cwmp::Message::get_parameter_names_response
                    when "SetParameterValues"
                        puts "got #{message_type}"
                        resp = c.post @acs_url, Cwmp::Message::set_parameter_values_response
                end
            end
            puts "got #{resp.status}, closing"
        end


    end


end