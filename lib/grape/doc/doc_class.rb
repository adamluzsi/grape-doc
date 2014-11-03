module GrapeDoc

  class ApiDocumentation < Array

    def create(type,*args)
      raise(ArgumentError,'invalid type') unless [String,Symbol].any?{ |klass| type.class <= klass }
      return Helpers.constantize("GrapeDoc::ApiDocParts::#{Helpers.camelize(type)}").new(*args)
    end

    def add(type,*args)
      self.push(create(type,*args))
    end

    def br(int=1)
      raise unless int.class <= Integer
      int.times{self.push(ApiDocParts::Br.new("\n"))}
    end

    def to_textile
      require 'RedCloth'
      RedCloth.new(self.map{|e| e.to_textile }.join("\n"))
    end;alias to_s to_textile

  end

end