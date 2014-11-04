module GrapeDoc
  class Generator

    attr_accessor :file_path
    def initialize(opts={})
      
      raise(ArgumentError,'invalid options given') unless opts.class <= Hash
      opts.merge!(
          {
              format: 'html'
          }.merge(opts)
      )

      self.file_path= opts[:path] || opts['path'] || File.join(Helpers.doc_folder_path,'api_doc.html')

      process_head
      process_table_of_content
      process_endpoints

    end

    def document
      @api_doc ||= ApiDocumentation.new
    end

    def save

      File.write self.file_path,
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
            if -> { @poc_data[route_path_var][route.route_method.to_s.upcase] rescue nil }.call
              poc_opts = @poc_data[route_path_var][route.route_method.to_s.upcase]

              document.add :h3,'Response'
              # document.add :raw,poc_opts['response'].to_yaml
              document.add :h4,'body'
              document.add :raw,poc_opts['response']['raw_body']

              document.add :h5,'options:'

              document.add :list,[
                  "'status code: #{poc_opts['response']['status']}",
                  "format: #{poc_opts['response']['format']}"
              ]


              document.add :h4,'example'

              document.add :h5,'curl sample'

              document.add :raw,[
                  "curl ",
                  "-X #{route.route_method.to_s.upcase} ",
                  "\"http://api_url#{route_path_var}?",
                  "#{poc_opts['request']['query']['raw']}\" ",
                  poc_opts['request']['headers'].select{
                      |k,v| k != 'HTTP_HOST' &&  v != ''
                  }.map{|k,v| "-H \"#{k.to_s.sub(/^HTTP_/,'')}: #{v}\"" }.join(' ')
              ].join

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
