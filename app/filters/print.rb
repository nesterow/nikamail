module Mireka
  
  class PrintSonethingFilterImpl < SimpleEmailDataFilter
    def getInputStream
      puts @data
    end
  end
  
  class PrintSomethingFilter < EmailFilter
    def filter
      PrintSonethingFilterImpl
    end
  end

end