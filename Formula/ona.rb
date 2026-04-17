class Ona < Formula
  desc "A beautiful markdown to HTML renderer that opens in your browser"
  homepage "https://github.com/Proteusiq/ona"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Proteusiq/ona/releases/download/v0.1.1/ona-aarch64-apple-darwin.tar.xz"
      sha256 "d911d5a85b6a298e5be1ba84b6081cd47fc399bf3a506d286d00affe74a795be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Proteusiq/ona/releases/download/v0.1.1/ona-x86_64-apple-darwin.tar.xz"
      sha256 "5f340643eceb59fe27df947b11715d62f94589880831bcc97e5a20f465f35046"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Proteusiq/ona/releases/download/v0.1.1/ona-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "af9cd75cd65d9360bb6d9eac9a492f42eb62e6cf9e94c15b818f9ddd4a52174e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Proteusiq/ona/releases/download/v0.1.1/ona-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c50461b6d17eba4b599dec7f0a4de7225bf1034e168ba5955e82dd3c12d4a6cb"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    bin.install "ona" if OS.mac? && Hardware::CPU.arm?
    bin.install "ona" if OS.mac? && Hardware::CPU.intel?
    bin.install "ona" if OS.linux? && Hardware::CPU.arm?
    bin.install "ona" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
