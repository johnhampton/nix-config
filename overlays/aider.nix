{ ... }: final: prev:
let
  # Add punkt tokenizer derivation
  punkt_tokenizer = prev.stdenv.mkDerivation {
    name = "nltk-punkt";
    src = prev.fetchurl {
      url = "https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/tokenizers/punkt_tab.zip";
      sha256 = "1vapcvqz71s6j3xj5ycvh6i3phcp2dhammw9azfgpvrqswinrcf2";
    };
    buildInputs = [ prev.unzip ];
    installPhase = ''
      mkdir -p $out/nltk_data/tokenizers
      unzip $src -d $out/nltk_data/tokenizers/
    '';
  };

  extraDependencies = with prev.python3.pkgs; [
    dataclasses-json
    deprecated
    dirtyjson
    filetype
    joblib
    llama-index-core
    llama-index-embeddings-huggingface
    marshmallow
    mpmath
    mypy-extensions
    nest-asyncio
    nltk
    safetensors
    scikit-learn
    sentence-transformers
    sqlalchemy
    sympy
    tenacity
    threadpoolctl
    transformers
    typing-inspect
    wrapt
  ];

  addDeps = pkg: pkg.overridePythonAttrs (oldAttrs: {
    dependencies = oldAttrs.dependencies ++ extraDependencies;
    makeWrapperArgs = (oldAttrs.makeWrapperArgs or []) ++ [
      "--set NLTK_DATA ${punkt_tokenizer}/nltk_data"
    ];
  });
in
{
  aider-chat = addDeps (addDeps prev.aider-chat).withPlaywright;
}
