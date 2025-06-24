# .zshrc
# juanfal 2025-06-24
#

export PATH="/opt/homebrew/bin:$PATH"
export LANG=es_ES.UTF-8
export LC_ALL=es_ES.UTF-8



es_interactivo() {
  # 1. No es shell interactivo
  [[ $- != *i** || "${NO_INTERACTIVO:-0}" == "1" ]] && return 0

  # 2. No está Terminal al frente
  local app
  app=$(osascript -e 'tell application "System Events" to name of first application process whose frontmost is true' 2>/dev/null) || return 0
  [[ "$app" != "Terminal" ]] && return 0

  # 3. Terminal al frente, pero mostrando un man
  local nombre_ventana
  nombre_ventana="$(osascript -e 'tell application "Terminal" to get name of front window'  2>/dev/null)"
  [[ "$nombre_ventana" == man* ]] && return 0

  # Si pasó todos los filtros, es interactivo
  return 1
}

es_interactivo && return 0



# PATHs y certificados
export PATH="$PATH:/Users/juanfc/.local/bin:/Applications/calibre.app/Contents/MacOS"
export SSL_CERT_FILE="/opt/homebrew/opt/openssl@3/etc/openssl@3/cert.pem"
export TERMINFO="/usr/share/terminfo"


##### FPATH y autocompletado (con compinit) #####
if type brew &>/dev/null; then
  brew_path="$(brew --prefix)/share/zsh/site-functions"
  [[ ":$FPATH:" != *":$brew_path:"* ]] && FPATH="$brew_path:$FPATH"
fi


webman() { open "http://mirrors.ccs.neu.edu/cgi-bin/unixhelp/man-cgi?$1"; }

xmanpage() {
  local cmd="man"
  [[ -n $2 ]] && cmd+=" $2"
  cmd+=" $1"

  osascript <<EOF
tell application "Terminal"
  activate
  set win to (make new window)
  do script "$cmd" in front window
  set current settings of front window to settings set "Man Page"
  set bounds of front window to {200, 100, 1200, 800}
end tell
EOF
}
closeman() {
  osascript -e 'tell application "Terminal" to close (every window where name of current settings of every tab contains "Man Page")'
}


tman () { MANWIDTH=160 MANPAGER='col -bx' man "$@" | subl ; }




function mann() {
  if [[ -z "$1" ]]; then
    echo "Uso: man_newwin <comando>"
    return 1
  fi

  osascript <<EOF
tell application "System Events"
  tell application process "Terminal"
    key down option
    delay 0.1
    click menu item "Man Page" of menu "Nueva ventana" of menu item "Nueva ventana" of menu "Shell" of menu bar 1
    delay 0.1
    key up option
  end tell
end tell

tell application "Terminal"
  set win to front window
  tell application "Finder"
    set screenBounds to the bounds of window of desktop
    set screenWidth to item 3 of screenBounds
  end tell
  set bounds of win to {screenWidth - 550, 60, screenWidth - 100, 960}

  do script "LESS='-sR' man $1" in win
end tell
EOF
}


