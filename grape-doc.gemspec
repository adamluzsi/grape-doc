# coding: utf-8

Gem::Specification.new do |spec|

  spec.name          = 'grape-doc'
  spec.version       = File.open(File.join(File.dirname(__FILE__),'VERSION')).read.split("\n")[0].chomp.gsub(' ','')
  spec.authors       = ['Adam Luzsi']
  spec.email         = ['adamluzsi@gmail.com']

  spec.description   = %q{ Documentation generator for Grape module compatible with Redmine/textile and Html formats }
  spec.summary       = %q{ Documentation generator for Grape module }

  spec.homepage      = "https://github.com/adamluzsi/#{__FILE__.split(File::Separator).last.split('.').first}"
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'

  spec.add_dependency 'grape'
  spec.add_dependency 'loader'
  spec.add_dependency 'RedCloth'
  spec.add_dependency 'rack-test'
  spec.add_dependency 'rack-test-poc','>= 3.0.0'

end
