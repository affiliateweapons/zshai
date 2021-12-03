alias gcp="gcloud projects list"
alias gcsp="gcloud config set project"
#alias gc="gcloud"
alias gci="gcloud components install"
alias gcl="gcloud components list"
alias aa="apk add --no-cache"



alias gccs="gcloud config set"
alias gccl="gcloud config list"



gcbe() {
gcloud beta billing projects describe \
  gcloud config get-value project \
  --format="value(billingEnabled)"
}

gc() {
  gcloud $@
}
