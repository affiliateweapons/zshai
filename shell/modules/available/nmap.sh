
subdomains() {
  local domain="${1:-kali.org}"
   nmap --script hostmap-crtsh.nse $domain
}
