require 'nokogiri'

module Cwmp
    module Message

        class GetParameterValuesResponse < Cwmp::Message::BaseMessage

            def self.build
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

        end

    end

end
