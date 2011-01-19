require 'pp'
require 'rubygems'

# use 'vi' to interactive edit contents of irb command line
require 'interactive_editor'

# add hack for 'less' paging - see https://github.com/dadooda/irb_hacks
require 'irb_hacks'

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

if ENV.include?('RAILS_ENV') &&
   !Object.const_defined?('RAILS_DEFAULT_LOGGER')

  # Log to STDOUT if in Rails
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)

  # re-establish db connection
  def reconnect!
     ActiveRecord::Base.connection.reconnect!
     "reconnected :-)"
  end

  begin # some PAM specific convenience methods

    # page the text of most recent pam application error email
    def last_error
      less Email.find_with_deleted(:first, :conditions => "subject like '[pam%'", :order => "id desc").body
    end

    # shorthand for getting report of last 10 actions in PAM
    def recent_activity
      AccessAuditRecord.recent_activity :as => 'table'
    end

  end

end

