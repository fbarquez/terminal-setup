
````markdown
# Terminal Setup by fbarquez

A customizable and interactive Zsh terminal dashboard, designed to improve focus, productivity, and provide meaningful daily context every time you open your terminal.

This script configures your Zsh shell with a sleek Powerlevel10k theme, weather forecast, motivational quotes, real-time news headlines, and more — all shown automatically at startup.

---

## Features

- Detects your real-time location (via IP) and shows **local weather**
- Fetches and displays a **motivational quote** at each startup
- Displays **top news headlines** using the [GNews API](https://gnews.io/)
- Shows a full interactive **terminal menu**
- Smart layout using `boxes` for style and clarity
- Detects if you're in an SSH session and logs each login
- Logs terminal sessions with timestamps (optional)
- Fully portable via an installation script (`install.sh`)

---

## Preview

```shell
[*] USER: fbarquez      DATE: Fri 24 May 2025 – 10:25
[*] HOST: my-laptop

        =====[ LOCAL WEATHER ]=====
[✓] Local weather in Berlin :: 🌤 +18°C

=====[ DAILY DOSE ]=====
Start where you are. Use what you have. Do what you can. — Arthur Ashe

=====[ TERMINAL MENU ]=====
1) View top news headline
2) View full weather report
3) Skip and enter shell
````

---

## Project Structure

```bash
my-terminal-setup/
├── .zshrc              # Main shell config (loads theme + dashboard logic)
├── .p10k.zsh           # Powerlevel10k theme configuration
├── .terminal_log       # (Optional) Keeps logs of each session with timestamp
├── install.sh          # Installation script to replicate on new machines
└── README.md           # This file 
```

---

## How to Use

### 1. Prerequisites

* A Debian/Ubuntu-based system
* Basic knowledge of terminal usage
* An internet connection (to pull weather/news quotes)
* Optional: GitHub API key for news (free): [Get it from GNews.io](https://gnews.io/)

---

### 2. Installation

Clone this repo and run the script:

```bash
git clone git@github.com:fbarquez/terminal-setup.git
cd terminal-setup
chmod +x install.sh
./install.sh
```

If you're on a system where you **already have configs you don't want to overwrite**, do **not** run the script. Instead, inspect each file manually:

```bash
cat .zshrc
cat install.sh
```

---

### 3. What's Inside the `install.sh`?

This script performs the following steps:

1. Installs dependencies (`zsh`, `jq`, `curl`, `boxes`, and `fonts-powerline`)
2. Copies `.zshrc`, `.p10k.zsh`, and optionally `.terminal_log` to your `$HOME`
3. Sets `zsh` as the default shell (if not already)
4. Clones `powerlevel10k` if missing
5. Shows you a reminder to restart the shell

All steps are **non-destructive**, unless you **already have `.zshrc` or `.p10k.zsh`**, in which case they will be overwritten. You can add a `backup` line in the script if you prefer safety.

---

## Logging

* All terminal sessions are logged to `.terminal_log` by default.
* SSH sessions are detected, and the connecting IP + time is shown at login.

---

## Motivational Quotes

* Pulled from [zenquotes.io](https://zenquotes.io/api/random)
* Fallback to a static quote if offline or API fails

---

## Weather Forecast

* Uses [wttr.in](https://wttr.in) and your IP to detect the **actual physical location** of your machine.
* It displays a brief forecast and temperature.

---

## News Headlines (optional)

* Uses [GNews.io API](https://gnews.io/)
* Free API key required, with a daily request limit
* Edit your `.zshrc` to insert your key as an environment variable:

```bash
export GNEWS_API_KEY="your_api_key_here"
```

---

## Customization

Want to show a custom city, more quotes, or different styles?

Edit `.zshrc` and tweak:

* `curl wttr.in/...` to change city format
* `quote=$(curl ...)` to use a different quotes API
* Change `boxes -d style` to switch visual layout

---

## Manual Restore (Optional)

If you need to re-run the startup dashboard manually:

```bash
source ~/.zshrc
```

---

## Tested On

* Ubuntu 22.04+
* Debian 12+
* Zsh 5.8+
* Terminal emulators: GNOME Terminal, Alacritty, Tilix

---

## Contributing

If you want to improve this script or suggest a new feature, feel free to fork this repo or open an issue.

---

## License

This project is licensed under the MIT License. You are free to reuse and modify it with attribution.

---

## Author

Made with by **[@fbarquez](https://github.com/fbarquez)**

> “The terminal is not just a tool — it’s your command center.”

````

---

