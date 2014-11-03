require_relative 'test_helper'
describe 'Object Space Collector' do

  specify 'test that there will be api classes on calling each_grape_class' do
    GrapeDoc::Helpers.each_grape_class do |api_class|
      api_class.must_be_instance_of Class
      (api_class < Grape::API).must_be :==, true

      api_class.respond_to?(:routes).must_be :==, true
      api_class.routes.respond_to?(:each).must_be :==, true

      api_class.routes.each do |r|
        r.route_method.must_be_instance_of String
        r.route_path.must_be_instance_of String
        r.route_params.must_be_instance_of Hash

      end

    end

  end

end