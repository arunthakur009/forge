{
  pkgs,
  ...
}:

{
  apps.pijul = {
    displayName = "Pijul";
    description = "Modern patch-based distributed version control system.";
    usage = ''
      Pijul is a distributed version control system based on a mathematical theory
      of patches, where independent changes always commute.

      #### Example

      Initialise a new repository

      ```
      pijul init
      ```

      Track files and record a change

      ```
      pijul add src/
      pijul rec -m "initial commit"
      ```

      Clone a remote repository

      ```
      pijul clone https://nest.pijul.com/pijul/pijul
      ```

      Push and pull changes

      ```
      pijul push origin
      pijul pull origin
      ```

      View change history

      ```
      pijul log
      ```
    '';

    links = {
      website = "https://pijul.org";
      source = "https://nest.pijul.com/pijul/pijul";
    };

    ngi.grants = {
      Core = [
        "Pijul"
        "Pijul-Hybrid"
      ];
    };

    programs = {
      packages = [
        pkgs.pijul
        pkgs.expect
      ];

      runtimes.shell = {
        enable = true;
      };
    };

    test.programs.script = ''
      pijul --version

      mkdir test-repo
      cd test-repo
      export HOME=$(pwd)
      export EDITOR=true

      pijul init
      mkdir src
      touch src/test.txt

      pijul add src --recursive

      cat << 'EOF' > pijul_expect.exp
      spawn pijul rec -m "initial commit"
      expect "Unique identity name"
      send "\r"
      expect "Display name"
      send "Test User\r"
      expect "Email"
      send "test@example.com\r"
      expect "change the encryption"
      send "n\r"
      expect "key to expire"
      send "n\r"
      expect "link this identity to a remote"
      send "n\r"
      expect eof
      EOF

      expect pijul_expect.exp

      pijul log | grep -q initial
    '';
  };
}
