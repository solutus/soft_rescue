
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'soft_rescue/version'

Gem::Specification.new do |spec|
  spec.name          = 'soft_rescue'
  spec.version       = SoftRescue::VERSION
  spec.authors       = ['Sergey Staskov']
  spec.email         = ['sergey.staskov@dellin.ru']

  spec.summary       = 'This gem helps to handle exceptions in soft manner using configured modes.'
  spec.description   = 'This gem helps to handle exceptions in soft manner using configured modes. Namely it can be configure not to raise exceptions but log it in systems like Sentry and Newrelic and return default value'
  spec.homepage      = 'https://github.com/solutus/soft_rescue'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
