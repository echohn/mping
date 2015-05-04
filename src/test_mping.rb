#!/usr/bin/env ruby

require 'test/unit'
require './lib/mping'

class TestStringNewMethod < Test::Unit::TestCase

  def test_string_is_a_ip
    assert_equal '1.1.1.1'.is_a_ip?, true
  end

  def test_string_is_not_a_ip
    assert_equal '999.999.999.999'.is_a_ip?, false
    assert_equal '1.999.999.999'.is_a_ip?, false
    assert_equal 'a.b.c.d'.is_a_ip?, false
    assert_equal 'www.baidu.com'.is_a_ip?, false
    assert_equal 'a1.2.3.4'.is_a_ip?, false
  end

  def test_string_is_a_ip_range
    assert_equal '1.1-3.4.5'.is_a_ip_range?, true
    assert_equal '1.1.1.1'.is_a_ip_range?, true
    assert_equal '{1,2}.2-3.{1,5,7}.1'.is_a_ip_range?, true
  end

  def test_string_is_not_a_ip_range
    assert_equal 'a1.1.1.1'.is_a_ip_range?, false
    assert_equal '{1.2,4}.3.5'.is_a_ip_range?, false
  end

  def test_ip_range_generate_ip_list
    test_cases = {
      '1.1.1.1-3'            => ['1.1.1.1','1.1.1.2','1.1.1.3'],
      '{1,3,5}.1.1.1'        => ['1.1.1.1','3.1.1.1','5.1.1.1'],
      '1-2.1.4-5.6'          => ['1.1.4.6','1.1.5.6','2.1.4.6','2.1.5.6'],
      '200-201.{99,101}.1.1' => ['200.99.1.1','200.101.1.1','201.99.1.1','201.101.1.1'],
      '255.255.255.255'      => ['255.255.255.255']
    }
    test_cases.each do |k,v|
      ip_range = IpRange.new(k)
      assert_equal ip_range.ip_list, v
    end
  end

end

