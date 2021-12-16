generate_run_script() {
  echo "#!/usr/bin/env /zsh" > run.sh
  echo $1 >> run.sh
  chmod +x run.sh
}
alias grun="generate_run-script"
