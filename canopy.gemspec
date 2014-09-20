Gem::Specification.new do |s|
  s.name              = 'canopy'
  s.version           = '0.0.1'
  s.date              = '2014-09-21'
  s.summary           = 'Amazon Web Services IAM key manager'
  s.description       = 'Assume the role of Amazon Web Services IAM users via a simple command-line interface'

  s.authors  = ["Tommy Johnson"]
  s.email    = 'tom@thebitcrusher.net'
  s.homepage = 'http://github.com/tommyjohnson/canopy'
  s.license  = 'MIT'

  s.require_paths = %w[lib]
  s.executables = ["canopy"]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md]

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec,tests}/*`.split("\n")
end
