module GrapeDoc
  class ApiDocParts

    class List < ArrayObject

      self.markdown = '*'

      def initialize(obj)
        obj = case obj
                when Array
                  obj

                when String,Symbol
                  obj.to_s.split("\n")

                else
                  raise(ArgumentError,'unknown format given for list object')

              end

        super(obj)

      end

    end

    class NumericalList < List
      self.markdown = '#'
    end



  end
end