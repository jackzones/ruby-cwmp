require 'nokogiri'

module Cwmp
    module Message

        class SetParameterValues < Cwmp::Message::BaseMessage

			def self.build(leaves)
				b = Nokogiri::XML::Builder.new

				b[:soap].Envelope(NAMESPACES) {
					b[:soap].Header {}
					b[:soap].Body {

						b[:cwmp].SetParameterValues() {
							b.ParameterList({"soap-enc:arrayType" => "cwmp:ParameterValueStruct[#{leaves[0].kind_of?(Array) ? leaves.size : '1'}]"}) {
								if leaves[0].kind_of?(Array)
									leaves.each do |leaf|
										b.ParameterValueStruct {
											b.Name leaf[0]
											b.Value leaf[1]
										}
									end
								else
									b.ParameterValueStruct {
										b.Name leaves[0]
										b.Value leaves[1]
									}
								end
								b.ParameterKey "asdads"
							}
						}
					}
				}

				return b.to_xml
			end
            
        end

    end

end
