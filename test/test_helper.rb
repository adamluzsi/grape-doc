require 'grape'
require 'rack/test'
require 'rack/test/poc'

require 'grape-doc'

require 'minitest/autorun'

class TestAPI1 < Grape::API

  version 'v1', using: :accept_version_header

  default_format :txt
  format :json

  content_type :txt,  'application/text'
  content_type :json, 'application/json'

  desc 'Hello world!'
  params do
    optional :test,
             type: String,
             desc: 'it\'s a test string'

  end
  get 'hello' do
    {hello: "world!"}
  end

end

class TestAPI2 < TestAPI1
end
