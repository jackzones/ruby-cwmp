require 'nokogiri'

module Cwmp
    module Message

        NAMESPACES = {"xmlns:soap" => "http://schemas.xmlsoap.org/soap/envelope/", "xmlns:soap-enc" => "http://schemas.xmlsoap.org/soap/encoding/", "xmlns:cwmp" => "urn:dslforum-org:cwmp-1-0", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xml:xsd" => "http://www.w3.org/2001/XMLSchema", "xmlns" => "urn:dslforum-org:cwmp-1-0"}

        def self.parse_from_text txtmsg
            doc = Nokogiri::XML(txtmsg)
            txtmsg =~ /(\w+):Envelope/
            soap_ns = $1
            message_type = doc.css("#{soap_ns}|Body")[0].element_children[0].name

            m = Object.const_get("Cwmp").const_get("Message").const_get(message_type).new # creating class from classname variable
            m.message_type = message_type
            m.parsed_xml_doc = doc
            m.raw_xml_message = txtmsg
            return m
        end

        class BaseMessage

            attr_accessor :message_type, :raw_xml_message, :parsed_xml_doc

            def to_s
                @raw_xml_message
            end

        end

    end
end






