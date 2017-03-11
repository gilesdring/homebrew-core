class GstPluginsBaseAT010 < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "http://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-0.10.36.tar.bz2"
  sha256 "2cd3b0fa8e9b595db8f514ef7c2bdbcd639a0d63d154c00f8c9b609321f49976"

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gstreamer@0.10"

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-base-0.10.35/REQUIREMENTS and Homebrew formulae
  depends_on "orc" => :optional
  depends_on "gtk+" => :optional
  depends_on "libogg" => :optional
  depends_on "pango" => :optional
  depends_on "theora" => :optional
  depends_on "libvorbis" => :optional

  def install
    # gnome-vfs turned off due to lack of formula for it.
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --enable-introspection=no
      --enable-experimental
      --disable-libvisual
      --disable-alsa
      --disable-cdparanoia
      --without-x
      --disable-x
      --disable-xvideo
      --disable-xshm
      --disable-gnome_vfs
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer@0.10"].opt_bin/"gst-inspect-0.10"
    output = shell_output("#{gst} --plugin volume")
    assert_match version.to_s, output
  end
end