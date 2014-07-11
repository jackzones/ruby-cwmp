#!/usr/bin/env ruby

require 'cwmp'

class Agent < Cwmp::Cpe

end

a = Agent.new 'http://localhost:9292/acs'
a.poweron