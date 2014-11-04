require 'json'
module GrapeDoc
  class Generator

    attr_reader :options
    def initialize(opts={})
      
      raise(ArgumentError,'invalid options given') unless opts.class <= Hash
      @options = {
        'format' => 'html',
		'path'   => File.join(Helpers.doc_folder_path,'api_doc.html')
      }.merge(opts.reduce({}){|m,o| m.merge!(o[0].to_s => o[1]) ;m})

      process_head
      process_table_of_content
      process_endpoints

    end

    def document
      @api_doc ||= ApiDocumentation.new
    end

    def save

      File.write self.options['path'],
                 document.to_textile.to_html

      true;rescue;false
    end;alias save! save

    private

    def process_head
      document.add :h1, "Rest Api Documentation (#{RackTestPoc.root.split(File::Separator)[-1]})"
    end

    def process_table_of_content
      #TODO: Table of content here!
    end

    def process_endpoints

      # Iterates over all subclasses (direct and indirect)
      Helpers.each_grape_class do |rest_api_model|
        rest_api_model.routes.each do |route|

          next if route.route_path =~ /\(\.:format\)\(\.:format\)$/

          document.add :h2, "#{route.route_method.to_s.upcase}: #{route.route_path}"
          document.add :h3, 'Request'
          document.add :h4, 'description'
          var = case route.route_description

                  when Hash
                    (route.route_description.find{|k,v| k == 'desc' || k == :desc } || [])[1] || ''

                  when Array
                    route.route_description

                  else
                    route.route_description.to_s

                end

          document.add :list,[*var]

          if route.route_params.length > 0
            document.add :h4, 'params'

            route.route_params.each do |key,value|
              document.add :list,[
                  document.create(:text,key.to_s,:bold),
                  document.create(:list,value.map{ |k,v| "#{k}: #{v}" })
              ]

            end

          end

          route_path_var = route.route_path.to_s.sub(/\(\.:format\)$/,'')
          @poc_data ||= Helpers.poc_data
          if @poc_data && @poc_data.find{|k,v| k =~ /^#{route_path_var}/ }
            route_method_var = route.route_method.to_s.upcase

            poc_cases = @poc_data.select{|k,v|
              k =~ /^#{route_path_var}\.?/ && v.keys.include?(route_method_var)
            }

            document.add :h3,'Response'

            poc_cases.each do |poc_path,poc_data|
              poc_opts = poc_data[route_method_var] || next

              document.add :h4,'example'

              document.add :h5,'curl sample'
              document.add :raw,[
                  "$ curl ",
                  "-X #{route_method_var} ",
                  "\"http://#{ -> { poc_opts['response']['headers']['HTTP_HOST'] rescue 'example.org' }.call}",
                  "#{poc_path}?","#{poc_opts['request']['query']['raw']}\" ",
                  poc_opts['request']['headers'].map{|k,v| "-H \"#{k}: #{v}\"" }.join(' ')
              ].join

              document.add :list,[
                  "status code: #{poc_opts['response']['status']}",
                  "format type: #{poc_opts['response']['format']}"
              ]

              document.add :h6,'raw body'
              document.add :raw,poc_opts['response']['raw_body']

              if JSON.respond_to?(:pretty_generate)

                document.add :h6,'json formatted body with Class types'
                document.add :raw,
                             JSON.pretty_generate(
                                 ApiDocParts::Parser.typer(poc_opts['response']['body'])
                             )

              end


            end

            if -> { @poc_data[route_path_var][route.route_method.to_s.upcase] rescue nil }.call
              poc_opts = @poc_data[route_path_var][route.route_method.to_s.upcase]


            end


          end
        end
      end

    end

  end

  class << self

    def new(*args)
      Generator.new(*args)
    end

    def generate(*args)
      Generator.new(*args).save
    end;alias save generate

  end

end
