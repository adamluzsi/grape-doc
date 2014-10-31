module GrapeDoc
  module Generator

    def generate_doc(opts={})
      raise(ArgumentError,'invalid options given') unless opts.class <= Hash
      opts.merge!(
          {
              format: 'html'
          }.merge(opts)
      )

      doc_folder_path = File.join(RackTestPoc.root,'doc')
      File.mkdir(doc_folder_path) unless File.exist?(doc_folder_path) rescue nil
      api_doc = ApiDocumentation.new

      api_doc.add :h1, "#{$0} Rest Api Documentation"
      api_doc.br 2

      #TODO: Table of content here!

      # Iterates over all subclasses (direct and indirect)
      ::ObjectSpace.each_object(::Class) do |rest_api_model|
        next unless -> { rest_api_model < Grape::API rescue false }.call
        rest_api_model.routes.each do |route|

          api_doc.add :h2, "Request: #{route.route_method.to_s.upcase}: #{route.route_path}"
          api_doc.add :h3, 'description'
          var = case route.route_description

                  when Hash
                    route.route_description.find{|k,v| k == 'desc' || k == :desc }[1]

                  when Array
                    route.route_description.join

                  else
                    route.route_description

                end

          api_doc.add :list,[var]


        end
      end




      File.write File.join(doc_folder_path,'api_doc.html'), RedCloth.new(api_documentation.to_textile).to_html

    end

  end
  extend Generator
end
