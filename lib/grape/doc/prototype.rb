module GrapeDoc
  class ApiDocParts

    class StringBasic < String

      class << self
        def markdown=(obj)
          @markdown=obj
        end
        def markdown
          @markdown || self.to_s.split('::')[-1].downcase
        end
      end

      def initialize(*args)

        @opts = args.select{|e| e.class <= ::Hash }
        args -= @opts

        @opts = @opts.reduce({}){|m,o| m.merge!(o[0].to_s => o[1]) ;m}

        args[0] = Parser.parse(args[0])
        self.replace(args[0].to_s)
      end

      def markdown
        self.class.markdown
      end

      def to_textile
        case @opts['style'].to_s.downcase

          when /^mirror/
            "#{markdown}#{self}#{markdown}"

          when /^start/,/^begin/

            options = [
                @opts['class']  ? "#{@opts['class']}" : nil,
                @opts['id']     ? "##{@opts['id']}" : nil
            ].compact

            [
                markdown,
                options.empty? ? nil : "(#{options.join(' ')})",
                '. ',
                self.to_s
            ].compact.join

          else
            self.to_s

        end
      end

    end

    class StringObject < StringBasic
      def initialize(*args)
        super
        @opts['style']= 'start'
      end
    end

    class StringObjectEnded < StringObject
      def initialize(*args)
        super
        @opts['style']= 'mirror'
      end
    end

    class ArrayBasic < Array

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
              e.map{|e|

                text = if e.respond_to?(:to_textile)
                         e.to_textile
                       else
                         e.to_s
                       end

                "#{markdown}#{markdown} #{text}"

              }.join("\n")

            else
              "#{markdown} #{e}"

          end
        }.join("\n")
      end

    end

    class ArrayObject < ArrayBasic
    end

  end
end