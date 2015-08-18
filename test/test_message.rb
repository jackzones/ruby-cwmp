#!/usr/bin/env ruby

require_relative '../lib/cwmp/message.rb'
require "test/unit"

class TestMessage < Test::Unit::TestCase

    def test_inform
        inform = Cwmp::Message::inform "Moonar", "130978", "00001", "1 BOOT", "0.0.1"
        assert_equal(inform.class.to_s, "Cwmp::Message")
    end

    def test_inform_response
        inform_response = Cwmp::Message::inform_response
        assert(inform_response.to_s =~ /InformResponse/)
    end

end

