# Ruby CWMP

A ruby library to parse and generate CWMP messages. Includes an ACS server and a CPE simulator.

## Using the library to build CWMP messages

```ruby
require 'cwmp'

puts Cwmp::Message::inform_response
puts Cwmp::Message::get_parameter_values ["Device.ManagementServer.", "Device.Time."]
puts Cwmp::Message::set_parameter_values [["InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1.Enable", "Enabled"], ["InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.DHCPStaticAddress.1.Enable", "true"]]

```

## Running ACS server

just run `acs` command on your shell

```
$ acs
```

and acs will be up, using thin

## Running CPE simulatore

type `cpe` on your shell

```
$ cpe
```

and cpe simulator will be up, sending periodic messages every 30s and accepting incoming connection requests



