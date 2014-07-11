require 'httpclient'

module Cwmp

    class Cpe

        attr_accessor :serial, :oui, :software_version, :manufacturer, :state, :acs_url

        def initialize (serial, oui, software_version, manufacturer, acs_url)
            @serial = serial
            @oui = oui
            @software_version = software_version
            @manufacturer = manufacturer
            @state = '0 BOOTSTRAP'
            @acs_url = acs_url
        end

        def start
            c = HTTPClient.new

            resp = c.post @acs_url, Cwmp::Message::inform(@manufacturer, @oui, @serial, @state, @software_version)
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
                end
            end
            puts "got #{resp.status}, closing"

        end


    end


end