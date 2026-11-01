{ ... }: {
  # Enable OpenGL/Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Mesa optimizations
  environment.sessionVariables = {
    MESA_GL_THREAD = "true";
    MESA_DISK_CACHE_SINGLE_FILE = "1";
  };
}
