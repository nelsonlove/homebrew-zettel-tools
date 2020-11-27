class ZettelTools < Formula
  desc "CLI tools for The Archive.app"
  homepage "https://github.com/nelsonlove/zettel-tools"
  url "https://github.com/nelsonlove/zettel-tools/archive/main.tar.gz"
  license "GPL"
  revision 1
  head "https://github.com/nelsonlove/zettel-tools.git"
  version "0.0.1"
  sha256 "54909c5f39c5938c1577078468d7e84e547b95861dddb16a3d5cb5644fdbc704"

  depends_on "python@3.9"

  def install
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python#{xy}/site-packages"
    resource("click").stage do
      system "python3", "setup.py", "install", "--prefix=#{libexec}",
                        "--single-version-externally-managed",
                        "--record=installed.txt"
    end

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    require "open3"
    output = Open3.capture2("#{bin}/zk", stdin_data: "\n")
    # output[0] is the stdout text, output[1] is the exit code
    assert_match 'usage: main.py [-h] [-m] [query ...]', output[0].lines.first
  end
end