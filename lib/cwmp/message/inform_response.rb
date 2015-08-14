require 'nokogiri'

module Cwmp
    module Message

        class InformResponse < Cwmp::Message::BaseMessage

            def self.build
                m = Cwmp::Message::InformResponse.new

                m.message_type = "InformResponse"

                b = Nokogiri::XML::Builder.new

                b[:soap].Envelope(NAMESPACES) {
                    b[:soap].Header {}
                    b[:soap].Body {
                        b[:cwmp].InformResponse() {}
                    }
                }

                m.raw_xml_message = b.to_xml

                return m
            end

        end

    end

end