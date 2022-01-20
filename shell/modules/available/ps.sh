psx () {
  command ps -ax | grep -v '\[kworker' | grep --color=auto -v '0:00 \[' \
  | grep -v "/usr/libexec" \
  | grep -v "brave" \
  | grep -v "/lib/systemd/systemd" \
  | grep -v "/usr/sbin/chronyd" \
  | grep -v "/usr/sbin/rsyslogd" \
  | grep -v "/usr/bin/google_guest_agent" \
  | grep -v "/usr/bin/google_osconfig_agent" \
  | grep -v "/sbin/agetty"
}


ps1 () { ps fe }

psf() { command ps f }

pse() { ps e }

ps2() {
  [[ -z $1 ]] \
  && command [ps] ah \
  || command [ps] $@
}

