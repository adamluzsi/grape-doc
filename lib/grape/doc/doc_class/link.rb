module GrapeDoc
  class ApiDocParts

    class Link < StringObject

      def initialize(text,url)
        super(text)
        @url = url
      end

      def to_textile
        "\"#{self}\":#{@url}"
      end

    end

    class PictureLink < StringObjectEnded
      self.markdown = '!'
    end

  end
end