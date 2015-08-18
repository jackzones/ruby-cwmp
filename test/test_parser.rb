#!/usr/bin/env ruby

require "test/unit"

class TestParser < Test::Unit::TestCase

    def test_parsing_get_parameter_values_response
        txtmsg = '<soap:Envelope
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

        msg = Cwmp::Message::parse_from_text(txtmsg)
        assert_equal(msg.class.to_s, "Cwmp::Message")
		assert_equal(msg.message_type, "GetParameterValuesResponse")
    end

	def test_parsing_inform
		txtmsg = '<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:soap-enc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:cwmp="urn:dslforum-org:cwmp-1-0"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <soap:Header/>
    <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
        <cwmp:Inform>
            <DeviceId>
                <Manufacturer>Moonar</Manufacturer>
                <OUI>130978</OUI>
                <ProductClass>Router</ProductClass>
                <SerialNumber>00001</SerialNumber>
            </DeviceId>
            <Event>
                <EventStruct>
                    <EventCode>1 BOOT</EventCode>
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
                    <Value xsi:type="xsd:string">0.0.1</Value>
                </ParameterValueStruct>
                <ParameterValueStruct xsi:type="cwmp:ParameterValueStruct">
                    <Name>InternetGatewayDevice.DeviceInfo.SpecVersion</Name>
                    <Value xsi:type="xsd:string">1.0</Value>
                </ParameterValueStruct>
                <ParameterValueStruct xsi:type="cwmp:ParameterValueStruct">
                    <Name>InternetGatewayDevice.ManagementServer.ConnectionRequestURL</Name>
                    <Value xsi:type="xsd:string">http://127.0.0.1:9600/00001</Value>
                </ParameterValueStruct>
                <ParameterValueStruct xsi:type="cwmp:ParameterValueStruct">
                    <Name>InternetGatewayDevice.ManagementServer.ParameterKey</Name>
                    <Value xsi:type="xsd:string"/>
                </ParameterValueStruct>
                <ParameterValueStruct xsi:type="cwmp:ParameterValueStruct">
                    <Name>InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1.ExternalIPAddress
                    </Name>
                    <Value xsi:type="xsd:string">10.19.0.00001</Value>
                </ParameterValueStruct>
            </ParameterList>
        </cwmp:Inform>
    </soap:Body>
</soap:Envelope>'

		msg = Cwmp::Message::parse_from_text(txtmsg)
		assert_equal(msg.class.to_s, "Cwmp::Message")
		assert_equal(msg.message_type, "Inform")
		assert_equal(msg.supported_model, "TR-098")
	end

end

