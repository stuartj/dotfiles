require 'pp'
require 'rubygems'

# use 'vi' to interactive edit contents of irb command line
require 'interactive_editor'

require 'wirble'
Wirble.init
Wirble.colorize

# quick reload files - from http://themomorohoax.com/2009/03/27/irb-tip-load-files-faster
def rl(file_name = nil)
  if file_name.nil?
    if !@recent.nil?
      rl(@recent) 
    else
      puts "No recent file to reload"
    end
  else
    file_name += '.rb' unless file_name =~ /\.rb/
    @recent = file_name 
    load "#{file_name}"
  end
end

# Quickly dump a string into a file
def string2file(string,filename='string2file.txt',filepath='.')
  File.open("#{filepath}/#{filename}","w") do |f|
    f << string
  end
end

IRB.conf[:AUTO_INDENT] = true

# Log to STDOUT if in Rails
if ENV.include?('RAILS_ENV') &&
   !Object.const_defined?('RAILS_DEFAULT_LOGGER')

  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)

  def reconnect!
     ActiveRecord::Base.connection.reconnect!
     "reconnected :-)"
  end

end

