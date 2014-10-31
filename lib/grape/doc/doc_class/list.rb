module GrapeDoc
  class ApiDocParts

    class List < ArrayObject
      self.markdown = '*'

      def initialize()

      end

    end

    class NumericalList < List
      self.markdown = '#'
    end



  end
end