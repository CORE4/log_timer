require 'spec_helper'

describe LogTimer::Log do
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

  it 'stores the path' do
    log = LogTimer::Log.new(LOG_FILE_NEW)
    expect(log.path).to eq(LOG_FILE_NEW)
  end

  it 'checks for old files' do
    yesterday = Time.now - 24 * 60 * 60
    log = LogTimer::Log.new(LOG_FILE_OLD)
    expect(log.older?(yesterday)).to be true
  end

  it 'checks for new files' do
    yesterday = Time.now - 24 * 60 * 60
    log = LogTimer::Log.new(LOG_FILE_NEW)
    expect(log.older?(yesterday)).to be false
  end

  it 'returns the last couple of lines' do
    log = LogTimer::Log.new(LOG_FILE_NEW)
    expect(log.tail(10).size).to be 10
    expect(log.tail(10)[0]).to eq 'new line 10'
  end
end
