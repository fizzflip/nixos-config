{ inputs, ... }: {
  imports = [
    inputs.preload-ng.nixosModules.default
  ];

  services.preload-ng = {
    enable = true;
    usePrecompiled = false; # Compile natively from C source

    settings = {
      # Time quantum in seconds for process data gathering
      cycle = 20;

      # Memory thresholds (percentages relative to RAM states)
      memTotal = -10;
      memFree = 50;
      memCached = 0;
      memBuffers = 50;

      # Path prefixes for NixOS store and active system closure
      mapPrefix = "/nix/store/;/run/current-system/;!/";
      exePrefix = "/nix/store/;/run/current-system/;!/";

      # Modern prediction model: Variable Order Markov Model
      predictionAlgorithm = "VOMM";

      # Sorting strategy: 3 = Block sorting (I/O optimization)
      sortStrategy = 3;
    };
  };
}
