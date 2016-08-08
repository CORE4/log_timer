require 'log_timer/version'
require 'log_timer/log'
require 'log_timer/mailer'
require 'yaml'
require 'chronic_duration'

require 'pp'

module LogTimer
  class LogTimer
    attr_accessor :mailer, :config

    def initialize(config)
      @config = config
      @mailer = Mailer.new(@config[:mail])
    end

    def check
      @config[:files].each do |_key, file_info|
        log = Log.new(file_info[:path])
        if log.older?(Time.now - ChronicDuration.parse(file_info[:limit]))
          mailer.send(mail_subject(log), mail_body(log, file_info)) if @config[:cmd_options][:mail]
          puts "#{log.path} is older than the limit #{file_info[:limit]}" unless @config[:cmd_options][:quiet]
        end
      end
    end

    def mail_subject(log)
      "#{File.basename(log.path)} on #{@config[:hostname] || `hostname`} is getting old"
    end

    def mail_body(log, file_info)
      tail_limit = file_info[:tail_limit] || 10
      body = <<EOD
The log file #{log.path} is got older than the specified limit (#{file_info[:limit]}). Maybe a service stopped working.
The file was last changed on #{log.modification_date}.

The last #{tail_limit} lines are:
#{log.tail(tail_limit)}

Sincerely,
The LogTimer gem
EOD
      body
    end
  end
end
