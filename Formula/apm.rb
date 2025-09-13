class Apm < Formula
  desc "The apm application"
  homepage "https://aikyo.vercel.app/"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/akazdayo/aikyo-package-manager/releases/download/0.1.2/apm-aarch64-apple-darwin.tar.xz"
      sha256 "0e3e8637061ee3b90b57bd18c7c27effd357b3d3b30e809246d8d3bca734e6c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/akazdayo/aikyo-package-manager/releases/download/0.1.2/apm-x86_64-apple-darwin.tar.xz"
      sha256 "11005f758f9d458f387c2ad517400f4b3ffdb0affde17b792e9f5e2094b2c31b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/akazdayo/aikyo-package-manager/releases/download/0.1.2/apm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7ffd7ce13075a663ba12255f7276a09ff8110a86c177cb5d6826dcf05bd54524"
    end
    if Hardware::CPU.intel?
      url "https://github.com/akazdayo/aikyo-package-manager/releases/download/0.1.2/apm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4153319f9e90b08c07be04663c3d92155f973f76e08405070445ace5bff52df1"
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
