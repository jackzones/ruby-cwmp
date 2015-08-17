require 'nokogiri'

module Cwmp
    module Message

        class Reboot < Cwmp::Message::BaseMessage

            def self.build
                m = Cwmp::Message::Reboot.new
                m.message_type = "Reboot"
                b = Nokogiri::XML::Builder.new

                b[:soap].Envelope(NAMESPACES) {
                    b[:soap].Header {}
                    b[:soap].Body {
                        b[:cwmp].Reboot() {}
                    }
                }

                m.raw_xml_message = b.to_xml
                return m
            end

        end

    end

end