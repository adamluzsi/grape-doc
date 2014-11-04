require_relative 'test_helper'
describe 'Dummy test for rack-test-poc' do

  include Rack::Test::Methods

  def app
    TestAPI1
  end

  specify 'test the get call' do

    header("Accept-Version","v1")
    header("X-Token","blabla")
    get '/hello',test: 'hy'
    last_response.status.must_be :==, 200

    get '/hello.json'
    last_response.status.must_be :==, 200

  end

end