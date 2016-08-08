require 'net/smtp'

module LogTimer
  # Handles sending of mails via smtp or local (mail-utils)
  class Mailer
    attr_accessor :smtp_server, :smtp_port, :smtp_user, :smtp_password, :from, :to

    def initialize(options)
      @options = options
    end

    def send(subject, body)
      if @options[:smtp_server] && !@options[:smtp_server].empty?
        send_mail_smtp(compose_message(subject, body))
      else
        send_mail_local(subject, body)
      end
    end

    protected

    def compose_message(subject, body)
      to_addresses = [*@options[:to]].join(', ')
      message = <<EOD
From: Log Notifier <#{@options[:from]}>
To: <#{to_addresses}>
Subject: #{subject}

#{body}
EOD
      message
    end

    def send_mail_smtp(message)
      ::Net::SMTP.start(
          @options[:smtp_server],
          @options[:smtp_port],
          from_domain,
          @options[:smtp_user],
          @options[:smtp_password]) do |smtp|
        smtp.send_message message, @options[:from], @options[:to]
      end
    end

    def send_mail_local(subject, body)
      stdin, stdout, stderr, wait_thr = Open3.popen3("mail -s \"#{subject.gsub('"', '\"')}\" #{@options[:to].join(', ')}")
      stdin.puts body

      stdin.close  # stdin, stdout and stderr should be closed explicitly in this form.
      stdout.close
      stderr.close

      wait_thr.value == 0
    end

    def from_domain
      @options[:from].split('@')[1]
    end

  end
end
