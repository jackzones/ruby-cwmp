require 'nokogiri'

module Cwmp
    class MessageParser

        def initialize msg
            @msg = msg
        end

        def parse
            doc = Nokogiri::XML(@msg)
            @msg =~ /(\w+):Envelope/
            soap_ns = $1
            message_type = doc.css("#{soap_ns}|Body")[0].element_children[0].name

            m = Object.const_get("Cwmp").const_get("Message").const_get(message_type).new # creating class from classname variable
            m.message_type = message_type
            m.parsed_xml_doc = doc
            m.raw_xml_message = @msg
            return m

            # case message_type
            #     when "Inform"
            #         m = Cwmp::Message::Inform.new
            #         return m
            #     when "GetParameterValuesResponse"
            #         m = Cwmp::Message::GetParameterValuesResponse.new
            #         return m
            #     else
            #         raise "couldn't parse"
            # end
        end

    end

end
