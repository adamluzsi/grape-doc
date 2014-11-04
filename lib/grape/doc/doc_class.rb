module GrapeDoc

  class ApiDocumentation < Array

    def build(type,*args)
      raise(ArgumentError,'invalid type') unless [String,Symbol].any?{ |klass| type.class <= klass }
      return Helpers.constantize("GrapeDoc::ApiDocParts::#{Helpers.camelize(type)}").new(*args)
    end;alias create build

    def add(type,*args)
      self.push(create(type,*args))
    end

    def to_textile
      require 'RedCloth'
      RedCloth.new(self.map{|e| e.to_textile }.join("\n\n"))
    end;alias to_s to_textile

  end

end