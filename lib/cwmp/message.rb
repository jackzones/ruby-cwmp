require 'nokogiri'

module Cwmp
    class Message

        NAMESPACES = {"xmlns:soap" => "http://schemas.xmlsoap.org/soap/envelope/", "xmlns:soap-enc" => "http://schemas.xmlsoap.org/soap/encoding/", "xmlns:cwmp" => "urn:dslforum-org:cwmp-1-0", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xml:xsd" => "http://www.w3.org/2001/XMLSchema", "xmlns" => "urn:dslforum-org:cwmp-1-0"}
        attr_accessor :message_type, :raw_xml_message, :parsed_xml_doc

        def self.parse_from_text txtmsg
            doc = Nokogiri::XML(txtmsg)
            txtmsg =~ /(\w+):Envelope/
            soap_ns = $1
            message_type = doc.css("#{soap_ns}|Body")[0].element_children[0].name

            m = Cwmp::Message.new
            m.message_type = message_type
            m.parsed_xml_doc = doc
            m.raw_xml_message = txtmsg
            return m
        end


        def to_s
            return "CWMP Mess #{@message_type}"
        end

        def xml
            return @raw_xml_message
        end

        def supported_model
            if @raw_xml_message =~ /InternetGatewayDevice/
                return 'TR-098'
            else
                return 'TR-181'
            end
        end

        def self.reboot
            m = Cwmp::Message.new
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

        def self.reboot_response
            m = Cwmp::Message.new
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

        def self.inform(manufacturer, oui, serial, eventcodes, software_version)
            m = Cwmp::Message.new
puts "here we go"
            m.message_type = "Inform"
            m.raw_xml_message = '<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:soap-enc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:cwmp="urn:dslforum-org:cwmp-1-0"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <soap:Header>
        <cwmp:ID soap:mustUnderstand="1">37</cwmp:ID>
    </soap:Header>
    <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
        <cwmp:Inform>
            <DeviceId>
                <Manufacturer>'+manufacturer+'</Manufacturer>
                <OUI>'+oui+'</OUI>
                <ProductClass>Router</ProductClass>
                <SerialNumber>'+serial+'</SerialNumber>
            </DeviceId>
            <Event>
                <EventStruct>
                    <EventCode>'+eventcodes+'</EventCode>
                    <CommandKey/>
                </EventStruct>
            </Event>
            <MaxEnvelopes>1</MaxEnvelopes>
            <CurrentTime>2003-01-01T05:36:55Z</CurrentTime>
            <RetryCount>0</RetryCount>
            <ParameterList soap-enc:arrayType="cwmp:ParameterValueStruct[7]">
                <ParameterValueStruct xsi:type="cwmp:ParameterValueStruct">
                    <Name>InternetGatewayDevice.DeviceInfo.HardwareVersion</Name>
                    <Value xsi:type="xsd:string">MNR001</Value>
                </ParameterValueStruct>
                <ParameterValueStruct xsi:type="cwmp:ParameterValueStruct">
                    <Name>InternetGatewayDevice.DeviceInfo.ProvisioningCode</Name>
                    <Value xsi:type="xsd:string">ABCD</Value>
                </ParameterValueStruct>
                <ParameterValueStruct xsi:type="cwmp:ParameterValueStruct">
                    <Name>InternetGatewayDevice.DeviceInfo.SoftwareVersion</Name>
                    <Value xsi:type="xsd:string">'+software_version+'</Value>
                </ParameterValueStruct>
                <ParameterValueStruct xsi:type="cwmp:ParameterValueStruct">
                    <Name>InternetGatewayDevice.DeviceInfo.SpecVersion</Name>
                    <Value xsi:type="xsd:string">1.0</Value>
                </ParameterValueStruct>
                <ParameterValueStruct xsi:type="cwmp:ParameterValueStruct">
                    <Name>InternetGatewayDevice.ManagementServer.ConnectionRequestURL</Name>
                    <Value xsi:type="xsd:string">http://127.0.0.1:9600/'+serial+'</Value>
                </ParameterValueStruct>
                <ParameterValueStruct xsi:type="cwmp:ParameterValueStruct">
                    <Name>InternetGatewayDevice.ManagementServer.ParameterKey</Name>
                    <Value xsi:type="xsd:string"/>
                </ParameterValueStruct>
                <ParameterValueStruct xsi:type="cwmp:ParameterValueStruct">
                    <Name>InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1.ExternalIPAddress
                    </Name>
                    <Value xsi:type="xsd:string">10.19.0.'+serial+'</Value>
                </ParameterValueStruct>
            </ParameterList>
        </cwmp:Inform>
    </soap:Body>
</soap:Envelope>'

            return m
        end

        def self.inform_response
            m = Cwmp::Message.new

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

        def self.change_du_state_response
            m = Cwmp::Message.new

            m.message_type = "ChangeDUStateResponse"

            b = Nokogiri::XML::Builder.new

            b[:soap].Envelope(NAMESPACES) {
                b[:soap].Header {}
                b[:soap].Body {
                    b[:cwmp].ChangeDUStateResponse() {}
                }
            }

            m.raw_xml_message = b.to_xml

            return m
        end

        def self.set_parameter_values(leaves)
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

        def self.get_parameter_values(leaves)
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

        def self.get_parameter_names_response
            m = Cwmp::Message.new

            m.message_type = "Inform"
            m.raw_xml_message = '<soap:Envelope
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

            return m
        end

        def self.get_parameter_values_response
            m = Cwmp::Message.new

            m.message_type = "Inform"
            m.raw_xml_message = '<soap:Envelope
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

            return m
        end

    end
end
