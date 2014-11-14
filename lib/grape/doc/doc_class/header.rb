module GrapeDoc
  class ApiDocParts

    module TOC
      class << self

        def add_header(header_obj)
          if [H1,H2].include? header_obj.class
            (@headers ||= []).push(header_obj)
          end
        end

        def create_toc
          @headers.map { |header_obj|
            [
                '*' * header_obj.markdown.scan(/\d+$/)[0].to_i,
                " \"#{header_obj.to_s}\":##{header_obj.instance_variable_get(:@opts)['id']}"
            ].join
          }.join("\n") + "\n\n"
        end

      end
    end

    class H1 < StringObject

      def initialize(*args)
        super
        @opts['id']= SecureRandom.uuid
        TOC.add_header(self)
      end

    end

    class H2 < H1
    end

    class H3 < H1
    end

    class H4 < H1
    end

    class H5 < H1
    end

    class H6 < H1
    end

    class Block < StringObject
      self.markdown = "bq"
    end

    class Br < StringBasic
    end

  end
end