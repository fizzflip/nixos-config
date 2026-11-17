{
  config,
  lib,
  pkgs,
  ...
}:
let
  antigravityCliHardened =
    pkgs.runCommand "antigravity-cli-${pkgs.antigravity-cli.version}"
      {
        nativeBuildInputs = [
          pkgs.perl
          pkgs.makeWrapper
        ];
        meta = pkgs.antigravity-cli.meta;
      }
      ''
        mkdir -p $out/bin
        cp -a ${pkgs.antigravity-cli}/bin/agy $out/bin/agy
        chmod +w $out/bin/agy

        # Neutralize Google Clearcut telemetry endpoint in binary (exact 31 bytes)
        # Replaces 'https://play.googleapis.com/log' with 'http://127.0.0.1:65535/clearcut'
        perl -pi -e 's|https://play.googleapis.com/log|http://127.0.0.1:65535/clearcut|g' $out/bin/agy

        # Wrap executable with zero-telemetry and privacy environment variables
        wrapProgram $out/bin/agy \
          --set ANTIGRAVITY_SENTRY_SAMPLE_RATE "0" \
          --set BAICODE_TELEMETRY_ENDPOINT_URL "http://127.0.0.1:65535" \
          --set OTEL_SDK_DISABLED "true" \
          --set DO_NOT_TRACK "1"
      '';
in
lib.mkIf (!config.my.packages.minimal) {
  environment.systemPackages = [
    pkgs.uv
    pkgs.gh
    pkgs.git
    pkgs.bun
    pkgs.yarn
    pkgs.pnpm
    pkgs.nodejs
    pkgs.python3
    pkgs.zed-editor
    antigravityCliHardened

    # Typst
    pkgs.typst
    pkgs.typstyle
    pkgs.typst-live
  ];

  # Machine-wide organization policy locking off telemetry and snippet tracking at the backend engine level
  environment.etc."antigravity/admin_settings.json".text = builtins.toJSON {
    telemetryEnabled = false;
    userDataCollectionForceDisabled = true;
    disableCodeSnippetTelemetry = true;
  };

  # Block Google Clearcut telemetry endpoints system-wide (Defense-in-depth)
  networking.hosts."127.0.0.1" = [
    "play.googleapis.com"
    "autopush-cloudcode-pa.sandbox.googleapis.com"
  ];
}
