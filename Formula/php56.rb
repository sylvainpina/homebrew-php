#encoding: utf-8
require File.expand_path("../../Abstract/abstract-php", __FILE__)

require 'formula'

class Php56 < AbstractPhp
  init
  url "http://php.net/get/php-5.6.14.tar.bz2/from/a/mirror"
  sha256 "36f295f11641c1839a5df00e693f685fd134c65e8a1d46e8ee0abae8662b2eb0"
  version "5.6.14"
  def php_version
    5.6
  end
  def php_version_path
    56
  end
end
