_: {
  # Enable i2c for ddcutil (display brightness/colour via DDC/CI)
  # Loads i2c-dev module, creates the i2c group, sets udev rules
  hardware.i2c.enable = true;

  # Safeguard USB Optical Mice & HID pointing devices: exempt from autosuspend to eliminate cursor lag
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c077", ATTR{power/control}="on"
    ACTION=="add", SUBSYSTEM=="usb", ENV{ID_USB_INTERFACES}=="*:030102:*", ATTR{power/control}="on"
  '';
}
