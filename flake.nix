{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";                                                                                                                                           
    nixpkgs-python.inputs = { nixpkgs.follows = "nixpkgs"; };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
      });

      devShells = forEachSystem
        (system:
          let
            # pkgs = nixpkgs.legacyPackages.${system};
            pkgs = import inputs.nixpkgs {
              config.allowUnfree = true;
              config.cudaSupport = true;
            };
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  packages = with pkgs; [
                    cudatoolkit
                    portaudio
                    (python3.withPackages (python-pkgs: with python-pkgs; [
                      jupyter-all
                      jupyter-server
                      ipykernel
                      ipywidgets

                      python-dotenv

                      pyaudio
                      sounddevice
                      rich
                      pyttsx3
                      jinja2

                      peft
                      accelerate
                      # diffusers
                      openai-whisper
                      torch
                      torchaudio
                      torchvision
                      transformers
                      ftfy
                      tensorboard
                      nltk
                      xformers

                      matplotlib
                      pandas
                      numpy
                    ]))
                  ];

              	enterShell = ''
              	  python -c "import torch; print(f'Cuda Enabled: {torch.cuda.is_available()}')"
              	'';

              	dotenv.enable = true;

              	languages.python = {
                  enable = true;
                  version = "3.12";
                  uv.enable = true;
                  venv.enable = true;
                  venv.requirements = ''
                    bitsandbytes
                    ipywidgets
                    datasets # hugging face datasets
                    llama-index
                    llama-index-agent-openai
                    llama-index-tools-google
                    llama-index-tools-wikipedia
                    langchain
                    langchain-cli
                    langchain-community
                    langchain-core
                    langchain-ollama
                    langchain-openai
                    langchain-text-splitters
                    langchainplus-sdk
                    langgraph
                    langgraph-checkpoint
                    langgraph-checkpoint-postgres
                    langgraph-checkpoint-sqlite
                  '';
                };
              }
            ];
          };
        }
      );
    };
}
