#!/usr/bin/ruby
# @Author: mehdi
# @Date:   2014-11-02 17:43:05
# @Last Modified by:   mehdi
# @Last Modified time: 2014-11-02 19:57:39

module MyMonitor
  class Cpu
    def initialize
    end

    def cpu_infos
      @cpu_usage = `top -l 1 | head -n 10 | grep 'CPU usage'`.chomp
    end
  end
end