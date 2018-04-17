
require 'mail'
require 'mail/fields'

module Mail
  class DkimField < StructuredField
    FIELD_NAME = 'dkim-signature'
    CAPITALIZED_FIELD = 'DKIM-Signature'

    def initialize(value = nil, charset = 'utf-8')
      self.charset = charset
      value = strip_field(FIELD_NAME, value) if respond_to?(:strip_field)
      super(CAPITALIZED_FIELD, value, charset)
      self
    end

    def encoded
      "#{name}:#{value}\r\n"
    end

    def decoded
      "#{name}:#{value}\r\n"
    end
  end
end
