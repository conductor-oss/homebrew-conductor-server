class Conductor < Formula
  desc "Conductor OSS Server"
  homepage "https://github.com/conductor-oss/conductor"
  url "https://github.com/conductor-oss/conductor/releases/download/v3.21.23/conductor-server-lite-standalone.jar"
  sha256 "b1ca967cd2f122de88a9d2d75b818498d88a0189cc590dd82a1489a83db6c372"
  license "Apache 2.0"

  depends_on "openjdk@21"

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

