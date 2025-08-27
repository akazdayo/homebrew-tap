class Apm < Formula
  desc "The apm application"
  homepage "https://aikyo.vercel.app/"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/akazdayo/aikyo-package-manager/releases/download/v0.1.1/apm-aarch64-apple-darwin.tar.xz"
      sha256 "eb71cb20b13708baaea2eb6a35313ea06236b0b5b9afbf1abf230d8be3698dd6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/akazdayo/aikyo-package-manager/releases/download/v0.1.1/apm-x86_64-apple-darwin.tar.xz"
      sha256 "1c9849364b1f1d091a4d15724eb3111d35aee04422453ff943b4fe38b9e64d38"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/akazdayo/aikyo-package-manager/releases/download/v0.1.1/apm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b06ebc898ab0c0daa38b65363e1305a6522e77786b95e854777a291f7eb7827a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/akazdayo/aikyo-package-manager/releases/download/v0.1.1/apm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c842bb6d1d5cd6505470c2ce29525cb4ad2dff3ccc89e1e209d951f2099055a"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "apm" if OS.mac? && Hardware::CPU.arm?
    bin.install "apm" if OS.mac? && Hardware::CPU.intel?
    bin.install "apm" if OS.linux? && Hardware::CPU.arm?
    bin.install "apm" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
