class Conductor < Formula
  desc "Conductor OSS Server"
  homepage "https://github.com/conductor-oss/conductor"
  url "https://github.com/conductor-oss/conductor/releases/download/v3.22.0-alpha1/conductor-server-lite-standalone.jar"
  sha256 "09994dc9e02a9210f3204b396262eda61ccbca97272258ed461377e294511ca7"
  license "Apache 2.0"

  depends_on "openjdk"

  def install
    libexec.install "conductor-server-lite-standalone.jar"
    (bin/"conductor").write <<~EOS
      #!/bin/bash
      exec java -jar #{libexec}/conductor-server-lite-standalone.jar "$@"
    EOS
    chmod 0755, bin/"conductor"
  end

  test do
    system "#{bin}/conductor", "--version"
  end
end

