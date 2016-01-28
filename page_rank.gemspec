# -*- encoding: utf-8 -*-
# stub: page_rank 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "page_rank"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jens Wille"]
  s.date = "2016-01-28"
  s.description = "Calculates the PageRank of a network."
  s.email = "jens.wille@gmail.com"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["COPYING", "ChangeLog", "README", "Rakefile", "lib/page_rank.rb", "lib/page_rank/version.rb", "spec/data/test-1.json", "spec/data/test-2.json", "spec/data/test-3.json", "spec/data/test-4.json", "spec/page_rank_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "http://github.com/blackwinter/page_rank"
  s.licenses = ["AGPL-3.0"]
  s.post_install_message = "\npage_rank-0.1.0 [2016-01-28]:\n\n* First release.\n\n"
  s.rdoc_options = ["--title", "page_rank Application documentation (v0.1.0)", "--charset", "UTF-8", "--line-numbers", "--all", "--main", "README"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.5.1"
  s.summary = "PageRank implementation for Ruby."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<gsl>, ["~> 1.16"])
      s.add_runtime_dependency(%q<nuggets>, ["~> 1.4"])
      s.add_development_dependency(%q<hen>, [">= 0.8.3", "~> 0.8"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<gsl>, ["~> 1.16"])
      s.add_dependency(%q<nuggets>, ["~> 1.4"])
      s.add_dependency(%q<hen>, [">= 0.8.3", "~> 0.8"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<gsl>, ["~> 1.16"])
    s.add_dependency(%q<nuggets>, ["~> 1.4"])
    s.add_dependency(%q<hen>, [">= 0.8.3", "~> 0.8"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
