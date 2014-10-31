module GrapeDoc
  class ApiDocParts

    class Table < ArrayObject

      def pust(*args)
        raise(ArgumentError,'invalid input for table!') if args.any?{|e| !(e.class <= Array) }
        super(*args)
      end

      def to_textile
        self.map{|row| row.join(' | ') }.join("\n")
      end
    end

  end
end