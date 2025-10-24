const projects = {
  "nvim-config":"D:/Projects/dev-configs/nvim-config",
  "alacritty-config":"D:/Projects/dev-configs/alacritty",
  "yazi-config":"D:/Projects/dev-configs/yazi",
  "zellij-config":"D:/Projects/dev-configs/zellij",
  "komorebic-config":"D:/Projects/dev-configs/komorebic",
  "wezterm-config":"D:/Projects/dev-configs/wezterm",
  "nushell-config":"D:/Projects/dev-configs/nushell",
  "nimc-demo": "D:/Projects/nimc/demo",
  "nimc-nvim-debian": "D:/Projects/nimc/nim_debian",
  "zig-ultralight": "D:/Projects/zig/ultralight-zig"
}

export const projectSource = $nu.default-config-dir| path join projects.nu;

def _projects_hints [] {
  let completions = $projects | transpose key value | get key
  return {
    options:{
      case_sensitive:false, 
      completion_algorithm:fuzzy,
      sort:false
    }
    completions:$completions 
  }
}
def get-project [name: string] {
  if $name == "" {
    pp --list
    return null;
  }
  try {
    let project = $projects | get $name;
    if ($project | describe)  == "string" {
      return { path: $project }
    }
    return $project;
  } catch {
    print $"Project \"($name )\" not found";
    pp --list;
    return null;
  }
}

# Open a project by name
export def --env pp [
  --list, #show all projects
  --update, #edit project.nu with nvim
  --refresh, #xclip refresh command
  --lc, # local cd
  --cd, # change directory to project path 
  --setup, #run env setup
  name: string@_projects_hints = ""
] {
  if $list {
    print ($projects | transpose key value | get key);
    return;
  }
  if $update {
    nvim $projectSource;
    pp --refresh;
    return;
  }
  if $refresh {
    const refreshCommand = "use $projectSource *"
    print $'Run "($refreshCommand )" to update the project list';
    $refreshCommand | clip 
    return;
  }
  let project = get-project $name;
  if $project == null { return ; }
  if $lc {
    do {
      cd $project.path;
      nvim .;
    }
    return;
  }
  cd $project.path;
  if $cd == false { nvim $project.path; };
}
