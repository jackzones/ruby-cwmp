#!/usr/bin/env

require 'cosmo'

acs = Cwmp::Acs.instance
puts acs.cpes
acs.GetParameterValues "A54FD", "ciao."