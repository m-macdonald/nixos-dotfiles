{
  pkgs
}:
pkgs.python39Packages.buildPythonPackage rec {
  pname = "pixiv-util";
  version = "20230105";

  src = pkgs.fetchFromGitHub {
    owner = "Nandaka";
    repo = "PixivUtil2";
    rev = "v${version}";
    sha256 = "sha256-2RdFWXIwOdZVGNw0lj8c/dwlyk3kkfYCXDUyd7EVq0I=";
  };

  buildInputs = with pkgs.python39Packages; [
    beautifulsoup4
    certifi
    demjson3
    mechanize
    pillow
    pysocks
    colorama
    cloudscraper
  ];
} 
