module GrapeDoc
  class ApiDocumentation

    module Parser
      class << self

        def parse(object)
          case object

            when Array
              object.map{|e| self.format_parse(*e) }

            else
              object

          end
        end

        def format_parse(text,*args)
          text = text.dup
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


      end
    end

  end
end