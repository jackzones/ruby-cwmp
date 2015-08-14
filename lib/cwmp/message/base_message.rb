require 'nokogiri'

module Cwmp
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




            def self.reboot
                b = Nokogiri::XML::Builder.new

                b[:soap].Envelope(NAMESPACES) {
                    b[:soap].Header {}
                    b[:soap].Body {
                        b[:cwmp].Reboot() {}
                    }
                }

                return b.to_xml
            end

            def self.get_parameter_values (leaves)
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

            def self.get_parameter_values_response
                return '<soap:Envelope
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:soap-enc="http://schemas.xmlsoap.org/soap/encoding/"
	xmlns:cwmp="urn:dslforum-org:cwmp-1-0"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<soap:Header>
	<cwmp:ID soap:mustUnderstand="1"></cwmp:ID>
</soap:Header>
<soap:Body>
<cwmp:GetParameterValuesResponse>
<ParameterList soap-enc:arrayType="cwmp:ParameterValueStruct[5]">
<ParameterValueStruct>
	<Name>InternetGatewayDevice.Time.NTPServer1</Name>
	<Value xsi:type="xsd:string">pool.ntp.org</Value>
</ParameterValueStruct>
<ParameterValueStruct>
	<Name>InternetGatewayDevice.Time.CurrentLocalTime</Name>
	<Value xsi:type="xsd:dateTime">2014-07-11T09:08:25</Value>
</ParameterValueStruct>
<ParameterValueStruct>
	<Name>InternetGatewayDevice.Time.LocalTimeZone</Name>
	<Value xsi:type="xsd:string">+00:00</Value>
</ParameterValueStruct>
<ParameterValueStruct>
	<Name>InternetGatewayDevice.Time.LocalTimeZoneName</Name>
	<Value xsi:type="xsd:string">Greenwich Mean Time : Dublin</Value>
</ParameterValueStruct>
<ParameterValueStruct>
	<Name>InternetGatewayDevice.Time.DaylightSavingsUsed</Name>
	<Value xsi:type="xsd:boolean">0</Value>
</ParameterValueStruct>
</ParameterList>
</cwmp:GetParameterValuesResponse>
</soap:Body>
</soap:Envelope>'
            end

            def self.set_parameter_values (leaves)
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


            def self.set_parameter_values_response
                return ''
            end

            def self.get_parameter_names_response
                return '<soap:Envelope
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:soap-enc="http://schemas.xmlsoap.org/soap/encoding/"
	xmlns:cwmp="urn:dslforum-org:cwmp-1-0"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<soap:Header>
	<cwmp:ID soap:mustUnderstand="1"></cwmp:ID>
</soap:Header>
<soap:Body>
<cwmp:GetParameterNamesResponse>
<ParameterList soap-enc:arrayType="cwmp:ParameterInfoStruct[17]">
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.LANDeviceNumberOfEntries</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.WANDeviceNumberOfEntries</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.DeviceInfo.</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.ManagementServer.</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.Time.</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.Layer3Forwarding.</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.LANDevice.</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.WANDevice.</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.X_00507F_InternetAcc.</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.X_00507F_LAN.</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.X_00507F_NAT.</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.X_00507F_VLAN.</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.X_00507F_Firewall.</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.X_00507F_Applications.</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.X_00507F_System.</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.X_00507F_Status.</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
<ParameterInfoStruct>
	<Name>InternetGatewayDevice.X_00507F_Diagnostics.</Name>
	<Writable>0</Writable>
</ParameterInfoStruct>
</ParameterList>
</cwmp:GetParameterNamesResponse>
</soap:Body>
</soap:Envelope>'
            end


        end

    end
end
