{...}: {
  modules.host.monitors = [
    {
      name = "DP-2";
      mode = {
        height = 1080;
        width = 1920;
        refreshRate = 143.981;
      };
      position = {
        x = 0;
        y = 0;
      };
    }
    {
      name = "DP-1";
      mode = {
        height = 1504;
        width = 2256;
        refreshRate = 170.071;
      };
      position = {
        x = 1920;
        y = 0;
      };
      primary = true;
    }
  ];
}
