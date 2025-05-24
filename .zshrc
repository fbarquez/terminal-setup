# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# --- Custom welcome script below ---
# --- SESSION LOG ---
log_file="$HOME/.terminal_log"
echo "$(date '+%Y-%m-%d %H:%M:%S') | user=$USER | host=$(hostname) | session=${SSH_TTY:-local}" >> "$log_file"

# --- SSH DETECTION ---
if [[ -n "$SSH_TTY" ]]; then
  ip=$(echo "$SSH_CLIENT" | awk '{print $1}')
  terminal_type=$(echo "$SSH_TTY" | awk -F'/' '{print $NF}')
  datetime=$(date '+%Y-%m-%d %H:%M:%S')

  echo ""
  echo "==========[ SSH SESSION DETECTED ]=========="
  echo "[*] From IP     : $ip"
  echo "[*] User        : $USER@$HOSTNAME"
  echo "[*] Terminal    : $terminal_type"
  echo "[*] Date        : $datetime"
  echo "============================================"
  return
fi

# --- CONNECTIVITY CHECK ---
ping -c 1 google.com &>/dev/null
if [[ $? -ne 0 ]]; then
  echo "[!] No internet connection. Skipping dashboard."
  return
fi

# --- COLORS ---
reset=$(tput sgr0)
bold=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
cyan=$(tput setaf 6)

# --- MOTIVATIONAL QUOTE FROM INTERNET ---
quote=$(curl -s https://zenquotes.io/api/random | jq -r '.[0] | "\(.q) — \(.a)"')

if [[ -z "$quote" ]]; then
  quote="You are capable of amazing things. (fallback quote)"
fi


# --- CLIMA PRECISO POR UBICACIÓN REAL ---
echo "[*] Detecting precise location (latitude/longitude)..." && sleep 0.5
my_coords=$(curl -s ipinfo.io/loc)  # Ej: 48.85,2.35

if [[ -n "$my_coords" ]]; then
  echo "[✓] Coordinates detected: $my_coords"
  my_city=$(curl -s ipinfo.io/city)
  weather_summary=$(curl -s "wttr.in/@$my_coords?format=1")


  if echo "$weather_condition" | grep -qi "rain"; then
    echo "[!!] WEATHER ALERT: Rain detected" | boxes -d diamond
    weather_color=$red
  elif echo "$weather_condition" | grep -qi "cloud"; then
    weather_color=$yellow
  else
    weather_color=$green
  fi

  weather_line="${weather_color}[✓] Local weather in $my_city :: $weather_summary${reset}"
else
  weather_line="[!] Could not determine coordinates or weather."
fi

# --- DASHBOARD ---
header=$(cat <<EOF
[*] USER: $USER       DATE: $(date '+%a %d %b %Y - %H:%M')
[*] HOST: $(hostname)

        =====[ LOCAL WEATHER ]=====
$weather_line

=====[ DAILY DOSE ]=====
$quote
EOF
)

echo "$header" | boxes -d parchment

# --- INTERACTIVE MENU ---
echo ""
echo "${cyan}=====[ TERMINAL MENU ]=====${reset}"
echo "1) View top news headline"
echo "2) View full weather report for current location"
echo "3) Skip and enter shell"
read "opt?[*] Choose an option [1-3]: "

case $opt in
1)
  echo "[*] Choose a topic (e.g. general, technology, science, world, sports, health)"
  read "topic?[*] Topic [default: general]: "
  topic=${topic:-general}
  echo "[*] Fetching top $topic news..." && sleep 0.5

  news=$(curl -s "https://gnews.io/api/v4/top-headlines?lang=en&topic=$topic&token=$GNEWS_API_KEY")

  # Limpieza de caracteres invisibles
  clean_news=$(echo "$news" | tr -d '\000-\037')

  # Verificación de formato JSON
  if echo "$clean_news" | jq empty 2>/dev/null; then
    count=$(echo "$clean_news" | jq '.articles | length')

    if [[ "$count" -gt 0 ]]; then
      echo "[+] NEWS ALERT: Fresh headlines available!" | boxes -d stone
      echo "$clean_news" | jq -r '.articles[0] | "[+] Headline: \(.title // "N/A")\n[+] Summary: \((.description // "N/A") | gsub("[\u0000-\u001F]"; ""))\n[+] Link: \(.url // "N/A")"' | boxes -d peek
    else
      echo "${yellow}[!] No $topic news available at the moment.${reset}"
    fi
  else
    echo "${yellow}[!] Failed to parse news. The API may be down, or the topic is invalid.${reset}"
  fi
  ;;
2)
  echo "[*] Full weather report for $my_city:" && sleep 0.5
  curl "wttr.in/$my_city"
  ;;
*)
  echo "[*] Proceeding to shell. Stay sharp."
  ;;
esac

echo "$reset"

# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.  
export ZSH="$HOME/.oh-my-zsh"

export GNEWS_API_KEY="6279de9cf64ba8d0948237090c24d8f6"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



