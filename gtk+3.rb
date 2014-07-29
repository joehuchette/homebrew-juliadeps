require 'formula'

class Gtkx3 < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/3.12/gtk+-3.12.2.tar.xz'
  sha256 '61d74eea74231b1ea4b53084a9d6fc9917ab0e1d71b69d92cbf60a4b4fb385d0'

  bottle do
    root_url 'https://juliabottles.s3.amazonaws.com'
    cellar :any
    revision 1
    sha1 'fab0dd67b0a806d19313f8f961619b24b34778b3' => :lion
    sha1 '56ae36345ef4d9d75ae23b649a3437e470f5b819' => :mavericks
    sha1 '7f61ba10fa2189305111e6b57d781d726d391aa0' => :mountain_lion
  end

  depends_on 'staticfloat/juliadeps/pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'staticfloat/juliadeps/glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'staticfloat/juliadeps/gdk-pixbuf'
  depends_on 'staticfloat/juliadeps/pango'
  depends_on 'staticfloat/juliadeps/cairo'
  depends_on 'staticfloat/juliadeps/atk'

  def install
    # gtk-update-icon-cache is used during installation, and
    # we don't want to add a dependency on gtk+2 just for this.
    inreplace %w[ gtk/makefile.msc.in
                  demos/gtk-demo/Makefile.in
                  demos/widget-factory/Makefile.in ],
                  /gtk-update-icon-cache --(force|ignore-theme-index)/,
                  "#{buildpath}/gtk/\\0"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--enable-quartz-backend",
                          "--disable-x11-backend",
                          "--enable-introspection=yes",
                          "--disable-schemas-compile"
    system "make install"
    # Prevent a conflict between this and Gtk+2
    mv bin/'gtk-update-icon-cache', bin/'gtk3-update-icon-cache'
  end
end
