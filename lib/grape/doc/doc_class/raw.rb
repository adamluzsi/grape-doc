module GrapeDoc
  class ApiDocParts

    class Raw < StringBasic

      def initialize(text)
        super(text)
      end

      def to_textile
        "<pre>#{self.to_s}</pre>"
      end

    end

    class Text < StringBasic
    end

  end
end