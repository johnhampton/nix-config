{ inputs }:
let
  foreign-env = inputs.plugin-foreign-env;
in
final: prev: {

  fishPlugins = prev.fishPlugins // {
    foreign-env = prev.fishPlugins.foreign-env.override
      {
        buildFishPlugin = attrs: final.fishPlugins.buildFishPlugin (attrs // {
          src = foreign-env;
          version = foreign-env.lastModifiedDate;
          patches = [ ];

          preInstall = ''
            sed -e "s|sed|${final.gnused}/bin/sed|" \
                -e "s|bash|${final.bash}/bin/bash|" \
                -e "s|\| tr|\| ${final.coreutils}/bin/tr|" \
                -i functions/fenv.main.fish
          '';
        });
      };
  };
}
