#!/usr/bin/env ruby

#
# scope_lambda.rb
#

require 'parser'
require 'unparser'

=begin

EXAMPLE USAGE:

  sl = ScopeLambda.new

=end
class ScopeLambda
  class << self
  end

  def initialize(your_source)
    @ast, @comments = Parser::CurrentRuby.parse_with_comments(your_source)
  end

  def find_scopes
    []
  end

  def unparse
    Unparser.unparse(@ast, @comments)
  end
end


if __FILE__ == $0
  require 'minitest/autorun'

  class ScopeLambdaTest < Minitest::Test

    def setup
      @sl = ScopeLambda.new(dummy_code)
    end

    def test_find_scopes
      arry = @sl.find_scopes
      assert_equal 2, arry.size
    end

    def test_unparse
      plus_newline = "#{@sl.unparse}\n"
      assert_equal dummy_code, plus_newline
    end

  end

  def dummy_code
    <<EOC
class DummyRailsModel
  # these scopes are not compatible with Rails 4
  scope(:featured, where(featured: true))
  scope(:by_name, version_table_join.order("name ASC"))
end
EOC
  end

  def get_fixtures_dir
    this_dir = File.dirname __FILE__
    File.join this_dir, '..', 'test', 'fixtures'
  end

  def read_fixture(fname)
    File.read(File.join get_fixtures_dir, fname)
  end

end
