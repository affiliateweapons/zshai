scraper-discord() {
  CLS="scrape-discord"

  $CLS::setup() {
    apt install python3
    ln -s /usr/bin/python3 /usr/bin/python
    apt install python3.9-venv
  }

  $CLS::venv() {
    local name="${1:-venv}"
    python -m venv "$name"
    source "$name"/bin/activate
    python -m pip install discum
  }

  $CLS::default() {
    local script="${1:-scraper.py}"
    [[ ! -f "$script" ]] && {
      [[ -f "venv/bin/activate" ]] && { scrape on && return } || {scrape venv &&  return }
    } || {
      python "$script"
    }
  }

  $CLS::on() {
    local name="${1:-venv}"
    source "$name"/bin/activate
    export LAST_VENV="$(last-value venv $name)"
  }

  $CLS::off(){
    deactivate
  }

  subcommands $CLS $@

}
