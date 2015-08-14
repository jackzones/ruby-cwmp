require 'nokogiri'

module Cwmp
    module Message

        class Inform < Cwmp::Message::BaseMessage

            def self.build(manufacturer, oui, serial, eventcodes, software_version)
                m = Cwmp::Message::Inform.new

                m.message_type = "Inform"
                m.raw_xml_message = '<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:soap-enc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:cwmp="urn:dslforum-org:cwmp-1-0"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <soap:Header/>
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


            def supported_model
                if @raw_xml_message =~ /InternetGatewayDevice/
                    return 'TR-098'
                else
                    return 'TR-181'
                end
            end
        end

    end

end