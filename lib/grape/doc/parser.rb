module GrapeDoc
  module Parser
    class << self

      def parse(object)
        case object

          when Array
            object.map{|e|
              case e
                when Array
                  e.dup

                else
                  self.format_parse(*e)

              end
            }

          else
            # self.format_parse(object)
            object

        end
      end

      def format_parse(text,*args)
        text = text.dup.to_s
        args.each do |command|
          case command.to_s.downcase

            when /^bold/
              text.replace("*#{text}*")

            when /^italic/
              text.replace("__#{text}__")

            when /^underlined/
              text.replace("+#{text}+")

            when /^superscript/
              text.replace("^#{text}^")

          end
        end;return text

      end

      def typer(obj)
        case obj

          when Array
            obj.map{ |e| typer(e) }

          when Hash
            obj.reduce({}){|m,o| m.merge!(o[0] => typer(o[1]) ) ;m}

          when Class,Module
            obj.to_s

          when String
            if -> { Helpers.constantize(obj) rescue false }.call
              if obj.to_s == 'TEST'
                'String'
              else
                obj.to_s
              end

            else
              'String'

            end

          else
            obj.class.to_s

        end

      end

    end
  end

end