module GrapeDoc
  module Helpers
    class << self

      def each_grape_class
        ::ObjectSpace.each_object(::Class) do |api_class|
          next unless -> { api_class < Grape::API rescue false }.call
          yield(api_class)
        end if block_given?
      end

      def doc_folder_path
        @doc_folder_path ||= -> {

          doc_folder_path = File.join(::RackTestPoc.root,'doc')
          Dir.mkdir doc_folder_path unless File.exist?(doc_folder_path)
          return doc_folder_path

        }.call
      end

      def poc_file_path
        return Dir.glob(
            File.join(RackTestPoc.root,'test','poc','*.{yml,yaml}')
        ).max_by(&File.method(:ctime))
      end

      def poc_data
        require 'yaml'
        YAML.load(File.read(poc_file_path))
      rescue;{}
      end

      # Tries to find a constant with the name specified in the argument string.
      #
      #   'Module'.constantize     # => Module
      #   'Test::Unit'.constantize # => Test::Unit
      #
      # The name is assumed to be the one of a top-level constant, no matter
      # whether it starts with "::" or not. No lexical context is taken into
      # account:
      #
      #   C = 'outside'
      #   module M
      #     C = 'inside'
      #     C               # => 'inside'
      #     'C'.constantize # => 'outside', same as ::C
      #   end
      #
      # NameError is raised when the name is not in CamelCase or the constant is
      # unknown.
      def constantize(camel_cased_word)
        names = camel_cased_word.split('::')

        # Trigger a builtin NameError exception including the ill-formed constant in the message.
        Object.const_get(camel_cased_word) if names.empty?

        # Remove the first blank element in case of '::ClassName' notation.
        names.shift if names.size > 1 && names.first.empty?

        names.inject(Object) do |constant, name|
          if constant == Object
            constant.const_get(name)
          else
            candidate = constant.const_get(name)
            next candidate if constant.const_defined?(name, false)
            next candidate unless Object.const_defined?(name)

            # Go down the ancestors to check it it's owned
            # directly before we reach Object or the end of ancestors.
            constant = constant.ancestors.inject do |const, ancestor|
              break const    if ancestor == Object
              break ancestor if ancestor.const_defined?(name, false)
              const
            end

            # owner is in Object, so raise
            constant.const_get(name, false)
          end
        end
      end


      # By default, +camelize+ converts strings to UpperCamelCase. If the argument
      # to +camelize+ is set to <tt>:lower</tt> then +camelize+ produces
      # lowerCamelCase.
      #
      # +camelize+ will also convert '/' to '::' which is useful for converting
      # paths to namespaces.
      #
      #   'active_model'.camelize                # => "ActiveModel"
      #   'active_model'.camelize(:lower)        # => "activeModel"
      #   'active_model/errors'.camelize         # => "ActiveModel::Errors"
      #   'active_model/errors'.camelize(:lower) # => "activeModel::Errors"
      #
      # As a rule of thumb you can think of +camelize+ as the inverse of
      # +underscore+, though there are cases where that does not hold:
      #
      #   'SSLError'.underscore.camelize # => "SslError"
      def camelize(term)
        string = term.to_s
        string.capitalize!
        string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
        string.gsub!('/', '::')
        string

      end

    end
  end
end