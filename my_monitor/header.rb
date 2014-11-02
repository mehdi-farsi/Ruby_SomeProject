# encoding: utf-8
#!/usr/bin/ruby
# @Author: mehdi
# @Date:   2014-11-02 17:42:54
# @Last Modified by:   mehdi
# @Last Modified time: 2014-11-02 18:51:15

module MyMonitor
  class Header < Hash
    def initialize
      self[:user] = "User: #{`echo $USER`}"
      self[:boot_time] = "Time since boot: #{`sysctl -n kern.boottime`.chomp}"
      self[:os_version] = "Mac OSX Version: #{`sw_vers -productVersion`.chomp}"
      self[:cpu_infos] = `sysctl -n machdep.cpu.brand_string`.chomp
      return self
    end

    private :[]=
  end  
end