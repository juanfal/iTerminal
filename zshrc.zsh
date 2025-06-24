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
