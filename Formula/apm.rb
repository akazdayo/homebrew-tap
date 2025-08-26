class Apm < Formula
  desc "The apm application"
  homepage "https://aikyo.vercel.app/"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/akazdayo/aikyo-package-manager/releases/download/v0.1.0/apm-aarch64-apple-darwin.tar.xz"
      sha256 "29728f6e25dac1d9064314325cafd51f4eb7acaf3c16933a7e16ce2dede31f65"
    end
    if Hardware::CPU.intel?
      url "https://github.com/akazdayo/aikyo-package-manager/releases/download/v0.1.0/apm-x86_64-apple-darwin.tar.xz"
      sha256 "8d62595165bb490be21c38bc93c89dd6c27fc1a75f858c3333de9c1dc10133b9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/akazdayo/aikyo-package-manager/releases/download/v0.1.0/apm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0f0c618afd91f2d2bdd0c77e22d19f1dc356f02902f11ec01daad7fe09b47cb4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/akazdayo/aikyo-package-manager/releases/download/v0.1.0/apm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fa7a6e15753c28d77cf8cdfe25f0a881eda4e39211269315fd0297e1df5f600b"
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
