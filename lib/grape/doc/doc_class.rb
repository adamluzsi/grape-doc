require 'grape/doc/doc_class/parser'
require 'grape/doc/doc_class/prototype'

require 'grape/doc/doc_class/list'
require 'grape/doc/doc_class/header'
require 'grape/doc/doc_class/sidebar'

module GrapeDoc

  class ApiDocumentation < Array

    def add(type,*args)
      raise(ArgumentError,'invalid type')       unless [String,Symbol].any?{ |klass| type.class <= klass }
      raise(ArgumentError,'invalid arguments')  unless [String,Symbol].any?{ |klass| args.any?{|e| e.class <= klass } }
      self.push(Helpers.constantize("GrapeDoc::ApiDocumentation::#{Helpers.camelize(type)}").new(*args))

    end

    def to_textile
      self.map{|e| e.to_textile }.join("\n")
    end;alias to_s to_textile

  end

end