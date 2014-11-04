require_relative 'test_helper'
describe 'Doc generating' do

  specify 'test documentation generator' do

    var = GrapeDoc.new
    GrapeDoc.generate path: File.join(__dir__,'sample.html')

  end

end