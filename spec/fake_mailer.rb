module LogTimer
  # FakeMailer for testing
  class FakeMailer
    attr_reader :last_body, :last_subject
    def initialize(config)
      @config = config
      @last_subject = nil
      @last_body = nil
    end

    def send(subject, body)
      @last_subject = subject
      @last_body = body
    end
  end
end
