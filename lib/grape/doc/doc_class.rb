module GrapeDoc

  class ApiDocumentation < Array

    def build(type,*args)
      raise(ArgumentError,'invalid type') unless [String,Symbol].any?{ |klass| type.class <= klass }
      return Helpers.constantize("GrapeDoc::ApiDocParts::#{Helpers.camelize(type)}").new(*args)
    end;alias create build

    def add(type,*args)
      self.push(create(type,*args))
    end

    def add_toc(*args)
      @toc_added ||= ->{

        args.map!{|e| Helpers.constantize("GrapeDoc::ApiDocParts::#{Helpers.camelize(e)}") }
        self.insert(1,ApiDocParts::TOC.new(*self.select{|e| args.any?{|klass| e.class == klass }}))
        true

      }.call
    end

    def to_textile
      require 'RedCloth'
      RedCloth.new(self.map{|e| e.respond_to?(:to_textile) ? e.to_textile : e.to_s }.join("\n\n"))
    end;alias to_s to_textile

  end

end