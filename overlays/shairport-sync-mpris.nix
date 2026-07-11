final: prev: {
  shairport-sync-mpris = prev.shairport-sync.overrideAttrs (old: {
    configureFlags = (old.configureFlags or [ ]) ++ [
      "--with-metadata"
      "--with-dbus-interface"
      "--with-mpris-interface"
    ];
    buildInputs = (old.buildInputs or [ ]) ++ [ prev.glib prev.dbus ];
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.pkg-config ];
  });
}
