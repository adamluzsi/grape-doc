require 'grape'
require 'rack/test'
require 'rack/test/poc'
require 'grape-doc'

require 'minitest/autorun'

class TestAPI < Grape::API

  version 'v1', using: :accept_version_header

  default_format :txt
  format :json

  content_type :txt,  'application/text'
  content_type :json, 'application/json'

  get '/hello' do

  end

end
