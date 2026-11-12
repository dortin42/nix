{ ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name = "dortin42";
      email = "dortin42@gmail.com";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
