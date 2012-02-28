Gem::Specification.new do |s|
  s.name = "give4each"
  s.version = File.read("VERSION")
  s.authors = ["pasberth"]
  s.description = %{Can write the oneliner as block like the Symbol#to_proc}
  s.summary = %q{Can write the oneliner as block like the Symbol#to_proc}
  s.email = "pasberth@gmail.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.homepage = "http://github.com/pasberth/give4each"
  s.require_paths = ["lib"]
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
