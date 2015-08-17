require 'nokogiri'

module Cwmp
    module Message

        class GetParameterNamesResponse < Cwmp::Message::BaseMessage

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
