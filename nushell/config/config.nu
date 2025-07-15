$env.config.show_banner = false
$env.config.shell_integration.osc133 = false

let keybindings = [
  {
      name: completion_menu
      modifier: none
      keycode: "--" 
      mode: [emacs vi_normal vi_insert]
      event: {
      until: [
        { send: menu name: completion_menu }
        { send: menunext }
      ]
    }
  }
]
