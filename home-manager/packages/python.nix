{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (python3.withPackages (ps: with ps; [
      ipykernel
      notebook
      jupyterlab
      pyzmq
      numpy
      pandas
      matplotlib
      scikit-learn
      scipy
      seaborn
      statsmodels
      sympy
      tensorflow
      keras
      torch
      wandb
    ]))
  ];
}
