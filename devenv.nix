{ pkgs, lib, config, inputs, ... }:

{
  packages = with pkgs; [
    git
    (python3.withPackages (python-pkgs: with python-pkgs; [
      jupyter-all
      ipywidgets
      python-dotenv
      matplotlib
      pandas
      numpy
      cudatoolkit
      torch
      torchaudio
      torchvision
    ]))
  ];

  enterShell = ''
    git --version
  '';

  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  languages.python = {
    enable = true;
    uv.enable = true;
    venv.enable = true;
    venv.requirements = ''
      huggingface_hub
    ''; # + (if pkgs.stdenv.isLinux then '' '')
  };
  # See full reference at https://devenv.sh/reference/options/
}
