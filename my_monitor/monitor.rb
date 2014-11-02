#!/usr/bin/ruby
# @Author: mehdi
# @Date:   2014-11-02 17:42:46
# @Last Modified by:   mehdi
# @Last Modified time: 2014-11-02 20:01:41

require './header'
require './cpu'
require './ram'

module MyMonitor
  class Monitor
    def initialize
      @headers = Header.new
      @cpu = Cpu.new
      @ram = Ram.new
    end

    def display_header
      @headers.each do |k, v|
        puts v
      end
      puts
    end

    def monitor
      while (42)
        print "\r" + @cpu.cpu_infos
        # extremely dirty but not the goal of exercice
        sleep(3) 
      end
    end
  end
end
