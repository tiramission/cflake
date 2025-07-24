pkgs: {
  mergeJsonPy = pkgs.writers.writePython3 "mergeJson.py" {
    libraries = [pkgs.python3Packages.json5];
  } (builtins.readFile ./mergeJson.py);
}
