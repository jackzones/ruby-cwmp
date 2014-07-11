#!/env ruby

require 'rubygems'
require 'readline'
require './lib/api.rb'


module Cwmp
    class CLI

        def initialize

        end

        def start


            list = [
                'GetParameterValues', 'SetParameterValues', 'Reboot', 'FactoryReset', 'Download', 'AddObject', 'DeleteObject',
                'help', 'quit', "waitMessage"
            ].sort

            comp = proc { |s| list.grep(/^#{Regexp.escape(s)}/) }

            Readline.completion_append_character = " "
            Readline.completion_proc = comp

            conn = Moses::Api::Connection.new 'localhost', 9292

            while line = Readline.readline('> ', true)
                case line
                    when "quit"
                        puts "Bye"
                        sys.exit(0)
                    when "help"
                        help
                    when "waitMessage"
                        puts "reading tree"
                        board = conn.wait_message("Inform")
                        puts board
                    when "list"
                        conn.list
                end
            end
        end

    end
end