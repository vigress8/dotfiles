function command_present
  test -x "$(command -v $argv[1])"
end

alias g git
alias v nvim
alias wget    'wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'
if command_present eza
  alias la      'eza --icons -a'
  alias ll      'eza --icons -l'
  alias lla     'eza --icons -la'
  alias ls      'eza --icons'
end
alias router-ip 'route -n | awk \'/^0\.0\.0\.0/ {print $2}\''
command_present yarnpkg; and alias yarn yarnpkg
command_present fdfind; and alias fd fdfind
command_present batcat; and alias bat batcat

abbr --add discordo "discordo -token \$DISCORD_AUTH_TOKEN"
