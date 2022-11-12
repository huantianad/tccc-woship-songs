{
  description = "song-pdfs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
        
        texlive = (pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-small
            songs hyperref carlito subfiles
            latexmk;
        });
        
        build-deps = [
          texlive
        ];
      in
      rec {
        defaultPackage = pkgs.stdenv.mkDerivation rec {
          pname = "song-pdfs";
          version = "0.1.0";

          src = ./.;

          buildInputs = build-deps;

          buildPhase = ''
            export TEXTMFHOME=$TMP/.cache/texlive
            export TEXMFVAR=$TMP/.cache/texlive/texmf-var/
          
            latexmk -pdflatex=lualatex -pdf
            
            cd songs
            latexmk -pdflatex=lualatex -pdf
            cd ..
          '';

          installPhase = ''
            mkdir -p $out/songs
            install main.pdf $out
            install songs/*.pdf $out/songs
          '';
        };

        devShell = pkgs.mkShell {
          nativeBuildInputs = build-deps;
        };
      }
    );
}
