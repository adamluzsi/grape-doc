require_relative 'test_helper'
describe 'Doc generating' do

  specify 'test documentation generator' do

    var = GrapeDoc.new
    puts var.document.to_textile
    File.write File.join(RackTestPoc.root,'test','sample.html'),
               var.document.to_textile.to_html

  end

end