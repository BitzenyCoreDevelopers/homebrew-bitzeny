class CpuminerMacchky < Formula
  desc "Bitzeny cpu miner (macchky)"
  homepage "https://github.com/macchky/cpuminer"
	url "https://github.com/macchky/cpuminer/archive/ea9175b7987628990d234b40a84bfde784d1f685.zip"
	version "2.6.0.1"
  sha256 "d2a0388e99fd018454a5da596a9419526c2c46bbc0fa5a2aa0894990c634fd3c"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "curl"
  #depends_on "boost"
  #depends_on "libevent"
  #depends_on "miniupnpc"
  depends_on "openssl"
  #depends_on "bsdmainutils" => :build unless OS.mac? # `hexdump` from bsdmainutils required to compile tests
  #depends_on "zeromq"
  needs :cxx11

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j4 -l2.5" if ENV["CIRCLECI"]
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? &&
      MacOS::Xcode.version >= "8.0"
      ENV.delete("SDKROOT")
    end

		ENV.append "CFLAGS", "-Ofast -march=native -mtune=native"
		#ENV.append "CFLAGS", "-funroll-loops -fomit-frame-pointer"
		ENV.append "CXXFLAGS", "-Ofast -march=native -mtune=native"
		#ENV.append "CXXFLAGS", "-funroll-loops -fomit-frame-pointer"
		ENV.append "CXXFLAGS", "-std=c++11"
		system "mkdir m4" if OS.mac?
		system "cp #{prefix}/../../../opt/curl/share/aclocal/libcurl.m4 m4/" if OS.mac?
		system "echo 'ACLOCAL_AMFLAGS = -I m4' >> Makefile.am" if OS.mac?
		#system "sed -ie 's/INCLUDES/AM_CPPFLAGS/g' Makefile.am" if OS.mac?
		system "sed -ie 's/aclocal/aclocal -I m4/g' autogen.sh" if OS.mac?
    system "./autogen.sh"
		system "./nomacro.pl"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end
