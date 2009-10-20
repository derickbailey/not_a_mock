require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'

desc "Default: run specs"
task :default => :spec

desc "Run all the specs for the notamock plugin."
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--colour']
  t.rcov = true
end

desc "Generate documentation for the notamock plugin."
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'NotAMock'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('MIT-LICENSE')
  rdoc.rdoc_files.include('TODO')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :jeweler do
	require 'jeweler'	
	Jeweler::Tasks.new do |gs|
		gs.name = "NotAMock"
		gs.summary = "A cleaner and DRYer alternative to mocking and stubbing with RSpec"
		gs.description = "A cleaner and DRYer alternative to mocking and stubbing with RSpec, using Arrange-Act-Assert syntax"
		gs.email = "pete@notahat.com"
		gs.homepage = "http://notahat.com/not_a_mock"
		gs.authors = "Pete Yandell"
		gs.has_rdoc = false	
		gs.files.exclude("NotAMock.gemspec", ".gitignore")
		gs.add_dependency('rspec', '>= 1.2.9')
	end
end
