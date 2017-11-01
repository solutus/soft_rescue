require 'simplecov'            # These two lines must go first
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'soft_rescue'

require 'minitest/autorun'
