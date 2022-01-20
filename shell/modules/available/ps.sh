psx () {
	command ps -ax | grep -v '\[kworker' | grep --color=auto -v '0:00 \[' \
  | grep -v "/usr/libexec" | grep -v "brave"
}
ps1 () { ps fe }

psf() { command ps f }

pse() { ps e }

ps2() {
  [[ -z $1 ]] \
  && command [ps] ah \
  || command [ps] $@
}

