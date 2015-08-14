#!/usr/bin/env ruby

require_relative '../lib/cwmp/message.rb'
require "test/unit"

class TestMessage < Test::Unit::TestCase

  def test_prova
    inform_response = Cwmp::Message::BaseMessage::inform_response
    assert(inform_response =~ /InformResponse/)
  end

end

