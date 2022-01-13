ps () {
	command ps -ax | grep -v '\[kworker' | grep --color=auto -v '0:00 \['
}



ps2() {
  [[ -z $1 ]] && \
$commands[ps]  ah  || 
$commands[ps] $@

}
