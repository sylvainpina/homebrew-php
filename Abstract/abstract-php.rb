#encoding: utf-8

require 'formula'
require 'etc'

class AbstractPhp < Formula
  def self.init
    # So PHP extensions don't report missing symbols
    skip_clean 'bin', 'sbin'
    depends_on 'curl'
    depends_on 'freetype'
    #depends_on 'tidy-html5'
    depends_on 'homebrew/dupes/zlib'
    depends_on 'jpeg'
    depends_on 'libpng'
    depends_on 'libtool'
    depends_on 'mysql'
    depends_on 'readline'
    depends_on 'zlib'
  end

  def config_path
    etc+"php/"+php_version.to_s
  end

  def default_config
    "./php.ini-development"
  end

  def install

    args = ["--prefix=#{prefix}",
            "--localstatedir=#{var}",
#            "--sysconfdir=#{config_path}",
            "--libexecdir=#{libexec}",
            "--mandir=#{man}",
            "--disable-cgi",
            "--disable-debug",
#            "--enable-bcmath",
            "--enable-calendar",
            "--enable-exif",
            "--enable-ftp",
            "--enable-fpm",
            "--enable-gd-native-ttf",
            "--enable-inline-optimization",
            "--enable-intl=no",
#            "--enable-mbregex",
            "--enable-mbstring",
#            "--enable-pcntl",
#            "--enable-shmop",
            "--enable-soap",
            "--enable-sockets",
#            "--enable-sysvmsg",
#            "--enable-sysvsem",
#            "--enable-sysvshm",
#            "--enable-wddx",
            "--enable-zip",
            "--with-apxs2=/usr/sbin/apxs",
            "--with-bz2=/usr",
            "--with-config-file-path=#{config_path}",
            "--with-config-file-scan-dir=#{config_path}/conf.d",
            "--with-curl=#{Formula.factory('curl').prefix}",
            "--with-freetype-dir=#{Formula['freetype'].opt_prefix}",
            "--with-fpm-user=#{Etc.getlogin}",
            "--with-gd",
#            "--with-gettext=#{Formula['gettext'].opt_prefix}",
#            "--with-iconv-dir=/usr",
#            "--with-icu-dir=#{Formula['icu4c'].opt_prefix}",
            "--with-jpeg-dir=#{Formula['jpeg'].opt_prefix}",
#            "--with-kerberos=/usr",
#            "--with-libedit",
#            "--with-mhash",
            "--with-mysql-sock=/tmp/mysql.sock",
            "--with-mysql=mysqlnd",
            "--with-mysqli=mysqlnd",
            "--with-openssl",
            "--with-pdo-mysql=mysqlnd",
            "--with-png-dir=#{Formula['libpng'].opt_prefix}",
            "--with-readline=#{Formula['readline'].opt_prefix}",
            #"--with-tidy=#{Formula['tidy-html5'].opt_prefix}",
            "--with-xmlrpc",
            "--with-zlib=#{Formula['zlib'].opt_prefix}",

           ]

#    system "./buildconf" if build.head?
    system "./configure", *args
    
    inreplace "Makefile",
    /^INSTALL_IT = \$\(mkinstalldirs\) '([^']+)' (.+) LIBEXECDIR=([^\s]+) (.+)$/,
    "INSTALL_IT = $(mkinstalldirs) '#{libexec}/apache2' \\2 LIBEXECDIR='#{libexec}/apache2' \\4"
    
    inreplace 'Makefile' do |s|
      s.change_make_var! "EXTRA_LIBS", "\\1 -lstdc++"
    end
    
    system "make"
    ENV.deparallelize # parallel install fails on some systems
    system "make install"

    config_path.install default_config => "php.ini" unless File.exist? config_path+"php.ini"

    chmod_R 0775, lib+"php"

#    system bin+"pear", "config-set", "php_ini", config_path+"php.ini"

  end

  def php_version
    raise "Unspecified php version"
  end

  def php_version_path
    raise "Unspecified php version path"
  end

end
