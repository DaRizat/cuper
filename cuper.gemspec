# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = "cuper"
  s.version = '0.0.0'

  s.required_rubygems_version = '>= 1.3.5'
  s.authors = ["Jack Bishop"]
  s.date = Date.today
  s.description = %q{Cucumber to popular wiki markup}
  s.email = "jack.bishop@synctree.com"

  s.homepage = "http://www.github.com/synctree/cuper"
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubygems_version = "1.3.6"
  s.summary = %q{Cucumber to popular wiki markup}

  s.require_path = "lib"
  s.files        = `git ls-files`.split("\n")
  s.executables  = ['cuper']
end
