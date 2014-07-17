

acs = Cwmp::Acs.instance
puts acs.cpes
acs.GetParameterValues "A54FD", "ciao."

acs.start_session "A54FD" do |cpe|

end
