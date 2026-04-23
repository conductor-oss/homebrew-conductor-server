class Conductor < Formula
  desc "Conductor OSS Server"
  homepage "https://github.com/conductor-oss/conductor"
  url "https://github.com/conductor-oss/conductor/releases/download/v3.23.0/conductor-lite-3.23.0.jar"
  sha256 "68025e308151ceb0c40788193ae61065d24dd8cd1e8bbbd03ae87e9c9591134f"
  license "Apache 2.0"
  version "3.23.0"

  depends_on "openjdk@21"

  def install
    libexec.install "conductor-lite-3.23.0.jar"
    (bin/"conductor").write <<~EOS
      #!/bin/bash
      exec java -jar #{libexec}/conductor-lite-3.23.0.jar "$@"
    EOS
    chmod 0755, bin/"conductor"
  end

  test do
    system "#{bin}/conductor", "--version"
  end
end
