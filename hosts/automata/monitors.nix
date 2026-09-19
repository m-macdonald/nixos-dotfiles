{...}: {
  modules.host.monitors = [
    {
      name = "DP-1";
      mode = {
        height = 2160;
        width = 3840;
        refreshRate = 240.016;
      };
      scale = 1.5;
      position = {
        x = 2560;
        y = 0;
      };
      primary = true;
    }
    {
      name = "DP-2";
      mode = {
        height = 1440;
        width = 2560;
        refreshRate = 170.071;
      };
      position = {
        x = 0;
        y = 0;
      };
    }
  ];
}
