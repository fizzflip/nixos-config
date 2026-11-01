{ ... }: {
  # Enable OpenGL/Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Mesa optimizations & single-file disk shader cache
  environment.sessionVariables = {
    MESA_GL_THREAD = "true";
    MESA_DISK_CACHE_SINGLE_FILE = "1";
    MESA_SHADER_CACHE_MAX_SIZE = "4G";
    GSK_RENDERER = "ngl";
  };
}
