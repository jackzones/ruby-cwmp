require 'rubygems'
require 'bundler/setup'
require 'faye/websocket'
require 'eventmachine'

Thread::abort_on_exception = true

module Cwmp
    module Api
        class Connection

            def initialize (host, port)
                q = Queue.new
                @t = Thread.new do
                    EM.run {
                        scheme = 'ws'
                        url = "ws://#{host}:#{port}/api"
                        headers = {}
                        @ws = Faye::WebSocket::Client.new(url, nil, :headers => headers)

                        @ws.onopen = lambda do |event|
                            # p [:open]
                            @ws.send("Hello, WebSocket!")
                            q.push("ready")
                        end

                        @ws.onmessage = lambda do |event|
                            # p [:message, event.data]
                            # ws.close 1002, 'Going away'
                        end

                        @ws.onclose = lambda do |event|
                            # p [:close, event.code, event.reason]
                            puts "disconnected"
                            EM.stop
                            exit 1
                        end
                    }
                end
                q.pop
                puts "Connected..."
            end

            def loop
                puts "looping"
                @t.join
                puts "loop quits"
            end

            def list
                puts "now listing stuff"
                @ws.send("abra")
            end

            def wait_message (msg)
                puts "waiting msg"
                @ws.send("cadabra")
                return "ciao"
            end

        end


    end
end