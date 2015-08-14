#!/usr/bin/env ruby

require_relative '../lib/cwmp/message.rb'
require "test/unit"

class TestMessage < Test::Unit::TestCase

    def test_inform
        inform = Cwmp::Message::Inform.build "Moonar", "130978", "00001", "1 BOOT", "0.0.1"
        assert_equal(inform.class.to_s, "Cwmp::Message::Inform")
    end

    def test_inform_response
        inform_response = Cwmp::Message::InformResponse.build
        assert(inform_response.to_s =~ /InformResponse/)
    end

end

