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
        end

    end

    module Message

        NAMESPACES = {"xmlns:soap" => "http://schemas.xmlsoap.org/soap/envelope/", "xmlns:soap-enc" => "http://schemas.xmlsoap.org/soap/encoding/", "xmlns:cwmp" => "urn:dslforum-org:cwmp-1-0", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xml:xsd" => "http://www.w3.org/2001/XMLSchema", "xmlns" => "urn:dslforum-org:cwmp-1-0"}

        # call this way: Cwmp::Message::parse_from_text(msg)
        def self.parse_from_text txtmsg
            parser = Cwmp::MessageParser.new txtmsg
            return parser.parse
        end

        class BaseMessage

            attr_accessor :message_type, :raw_xml_message, :parsed_xml_doc

            def to_s
                @raw_xml_message
            end

        end

    end
end






