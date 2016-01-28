require_relative 'lib/page_rank/version'

begin
  require 'hen'

  Hen.lay! {{
    gem: {
      name:         %q{page_rank},
      version:      PageRank::VERSION,
      summary:      %q{PageRank implementation for Ruby.},
      description:  %q{Calculates the PageRank of a network.},
      author:       %q{Jens Wille},
      email:        %q{jens.wille@gmail.com},
      license:      %q{AGPL-3.0},
      homepage:     :blackwinter,

      dependencies: {
        gsl:     '~> 1.16',
        nuggets: '~> 1.4'
      },

      required_ruby_version: '>= 1.9.3'
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
