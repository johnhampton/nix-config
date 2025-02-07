{ ... }: final: prev: {
  aider-chat = prev.aider-chat.withPlaywright.overridePythonAttrs (oldAttrs: {
    dependencies = oldAttrs.dependencies ++ (with prev.python3.pkgs; [
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
    ]);
  });
}
