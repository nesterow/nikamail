module Mireka
  
  class EmailFilter
    java_implements Mireka::FilterType
    java_signature 'Filter createInstance(MailTransaction mailTransaction)'
    
    class FilterImpl < Mireka::AbstractFilter
      def initialize(mailTransaction, filter)
        @filter = filter
        super(mailTransaction)
      end
      
      def data(maildata)
         chain.data(@filter.new(data));
      end
      
    end
    
    def createInstance(mailTransaction)
      return FilterImpl.new(mailTransaction, filter)
    end
    
    def filter
      raise "Not Implemented"
    end
    
  end
  
  class SimpleEmailDataFilter
    java_implements Mireka::MailData
    java_signature 'InputStream getInputStream() throws IOException'
    java_signature 'void writeTo(OutputStream out) throws IOException'
    java_signature 'public void dispose()'
    
    def initialize(data)
      @data = data
    end
    
    def writeTo(out)
      StreamCopier.writeMailDataInputStreamIntoOutputStream(self, out)
    end
    
    def dispose
      @data.dispose()
    end
    
    def getInputStream
      puts @data
      raise 'Not Implemented'
    end
    
  end

end