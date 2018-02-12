class CpuminerMacchky < Formula
  desc "Bitzeny cpu miner (macchky)"
  homepage "https://github.com/macchky/cpuminer"
	url "https://github.com/macchky/cpuminer/archive/master.zip"
	version "2.6.0"
  sha256 "17d6653347c5ae6e05a9c698942f210d02cac67ba7abc3091e07fd96b24e9d67"

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

		ENV.append "CFLAGS", "-O3"
		ENV.append "CXXFLAGS", "-O3"
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
