require 'nokogiri'

module Cwmp
    module Message

        class RebootResponse < Cwmp::Message::BaseMessage

            def self.build
                m = Cwmp::Message::RebootResponse.new
                m.message_type = "RebootResponse"
                b = Nokogiri::XML::Builder.new

                b[:soap].Envelope(NAMESPACES) {
                    b[:soap].Header {}
                    b[:soap].Body {
                        b[:cwmp].RebootResponse() {}
                    }
                }

                m.raw_xml_message = b.to_xml
                return m
            end

        end

    end

end