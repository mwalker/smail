#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__) + '/../../lib'

require 'smail'

require 'benchmark'

include Benchmark

simple_message = IO.read(File.dirname(__FILE__) + "/../email/multi-received.txt")
complex_message = IO.read(File.dirname(__FILE__) + "/../email/complex.txt")
attach_message = IO.read(File.dirname(__FILE__) + "/../email/attachment.txt")

bm(6) do |x|
  x.report("simple ") { 10_000.times { SMail.new(simple_message) } }
  x.report("complex") { 1_000.times { SMail.new(complex_message) } }
  x.report("attach ") { 100.times { SMail.new(attach_message) } }
end
