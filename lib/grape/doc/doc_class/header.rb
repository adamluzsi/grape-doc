module GrapeDoc
  class ApiDocParts

    class TOC

      def headers
        @headers ||= []
      end

      def initialize(*args)
        headers.push(*args)
      end

      def add_header(header_obj)
        headers.push(header_obj)
      end

      def to_textile
        headers.map { |header_obj|
          [
              '*' * header_obj.markdown.scan(/\d+$/)[0].to_i,
              " \"#{header_obj.to_s}\":##{header_obj.instance_variable_get(:@opts)['id']}"
          ].join
        }.join("\n") + "\n\n"
      end

      def clear
        headers.clear
      end


    end

    class H1 < StringObject

      def initialize(*args)
        super
        @opts['id']= SecureRandom.uuid
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