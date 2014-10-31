module GrapeDoc
  class ApiDocParts

    class StringBasic < String

      class << self
        def markdown=(obj)
          @markdown=obj
        end
        def markdown
          @markdown || self.to_s.downcase
        end
      end

      def initialize(object)
        object = Parser.parse(object)
        self.replace(object)
      end

      def markdown
        self.class.markdown
      end

      alias to_textile to_s

    end

    class StringObject < StringBasic

      def to_textile
        "#{markdown}. #{self.to_s}"
      end

    end

    class StringObjectEnded < StringObject

      def to_textile
        "#{markdown}#{self}#{markdown}"
      end

    end

    class ArrayObject < Array

      class << self
        def markdown=(obj)
          @markdown=obj
        end
        def markdown
          @markdown || self.to_s.downcase
        end
      end

      def initialize(object)
        object = Parser.parse(object)
        self.replace(object)
      end

      def markdown
        self.class.markdown
      end

      def to_textile
        self.map{|e|
          case e

            when ArrayObject
              e.map{|e| "#{markdown}#{e.to_textile}" }.join("\n")

            else
              "#{markdown} #{e}"

          end
        }.join("\n")
      end

    end

  end
end