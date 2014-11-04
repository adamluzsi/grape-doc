module GrapeDoc
  class ApiDocParts

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
              obj.map(&:typer)

            when Hash
              obj.reduce({}){|m,o| m.merge!(o[0] => typer(o[1]) ) ;m}

            when Class,Module
              obj

            else
              obj.class

          end

        end

      end
    end

  end
end