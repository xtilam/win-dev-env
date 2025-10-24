$env.config.show_banner = false
$env.config.shell_integration.osc133 = false
$env.config.keybindings = [
  {
    name: clear
    modifier: control
    keycode: char_l
    mode: [emacs vi_normal vi_insert]
    event: {
    send: executehostcommand
      cmd: "clear"
    }
  }
]

def --env use-cenv [...args: string] {
  let rs = (node $"($nu.default-config-dir)/json-env/print-env.mjs" ...$args) | from json;
  print $rs.logs;
  if $rs.exitCode != 0 {
    print $"Exit code: ($rs.exitCode)";
  }
  load-env $rs.env;
};

def debian [] {
  wsl -d debian -- bash --login;
}


use ./projects.nu *;
source ./alias.nu;
