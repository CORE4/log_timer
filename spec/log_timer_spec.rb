require 'spec_helper'
require_relative 'fake_mailer'

TEST_CONFIG = {
  cmd_options: {
    mail: true,
    quiet: true
  },
  mail: {
    smtp_server: 'example.com',
    smtp_port: 25,
    smtp_user: 'testuser',
    smtp_password: 'testpassword',
    from: 'notifications@core4dev.de',
    to: 'g.visscher@core4.de'
  },
  files: {
    old: {
      path: LOG_FILE_OLD,
      limit: '24h'
    },
    new: {
      path: LOG_FILE_NEW,
      limit: '24h'
    }
  }
}

describe LogTimer do
  before :all do
    File.open(LOG_FILE_NEW, 'w') do |file|
      20.times { |i| file.puts "new line #{i}" }
    end

    File.open(LOG_FILE_OLD, 'w') do |file|
      20.times { |i| file.puts "old line #{i}" }
    end
    old_time = Time.now - (30 * 24 * 60 * 60)
    File.utime(old_time, old_time, LOG_FILE_OLD) # Set modification time to last month
  end

  after :all do
    File.delete LOG_FILE_OLD
    File.delete LOG_FILE_NEW
  end

  it 'has a version number' do
    expect(LogTimer::VERSION).not_to be nil
  end

  it 'finds the old file' do
    log_timer = LogTimer::LogTimer.new(TEST_CONFIG)
    fake_mailer = LogTimer::FakeMailer.new({})
    log_timer.mailer = fake_mailer
    log_timer.check
    expect(fake_mailer.last_subject).to include(LOG_FILE_OLD)
  end

  it 'mails a part of the logs' do
    log_timer = LogTimer::LogTimer.new(TEST_CONFIG)
    fake_mailer = LogTimer::FakeMailer.new({})
    log_timer.mailer = fake_mailer
    log_timer.check
    expect(fake_mailer.last_body).to include('old line')
  end
end
