precmd() { print "" }

local user_host='%(!.%{$fg_bold[blue]%}.%{$fg_bold[blue]%})%n㉿%m%{$reset_color%}'
local user_symbol='%{$fg_bold[blue]%}%(!.#.$)%{$reset_color%}'
local current_dir='%{$fg_bold[white]%}%3~%{$reset_color%}'

local vcs_branch='$(git_prompt_info)$(hg_prompt_info)'
local rvm_ruby='$(ruby_prompt_info)'
local venv_prompt='$(virtualenv_prompt_info)'

ZSH_THEME_RVM_PROMPT_OPTIONS="i v g"

PROMPT="%{$fg[green]%}┌──(%{$reset_color%}${user_host}%{$fg[green]%})-[%{$reset_color%}${current_dir}%{$fg[green]%}]%{$reset_color%}${rvm_ruby}${vcs_branch}${venv_prompt}
%{$fg[green]%}└─%{$reset_color%}${user_symbol} "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=") %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}*%{$reset_color%}%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[yellow]%}"

ZSH_THEME_HG_PROMPT_PREFIX="$ZSH_THEME_GIT_PROMPT_PREFIX"
ZSH_THEME_HG_PROMPT_SUFFIX="$ZSH_THEME_GIT_PROMPT_SUFFIX"
ZSH_THEME_HG_PROMPT_DIRTY="$ZSH_THEME_GIT_PROMPT_DIRTY"
ZSH_THEME_HG_PROMPT_CLEAN="$ZSH_THEME_GIT_PROMPT_CLEAN"

ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg[red]%}("
ZSH_THEME_RUBY_PROMPT_SUFFIX=") %{$reset_color%}"

ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="%{$fg[green]%}("
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX=") %{$reset_color%}"
ZSH_THEME_VIRTUALENV_PREFIX="$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX"
ZSH_THEME_VIRTUALENV_SUFFIX="$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX"
