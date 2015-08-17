require 'nokogiri'

module Cwmp
    module Message

        class GetParameterValues < Cwmp::Message::BaseMessage

            def self.build(leaves)
                b = Nokogiri::XML::Builder.new

                b[:soap].Envelope(NAMESPACES) {
                    b[:soap].Header {}
                    b[:soap].Body {

                        b[:cwmp].GetParameterValues() {
                            b.ParameterNames({"soap-enc:arrayType" => "cwmp:string[#{leaves.kind_of?(Array) ? leaves.size : '1'}]"}) {
                                if leaves.kind_of?(Array)
                                    leaves.each do |leaf|
                                        b.string leaf
                                    end
                                else
                                    b.string leaves
                                end
                            }
                        }
                    }
                }

                return b.to_xml
            end

        end

    end

end