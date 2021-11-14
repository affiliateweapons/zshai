# remove old versions
sudo apt-get remove docker docker.io containerd runc -y

# update apt package
sudo apt-get update -y

# install packages to allow apt to use a repository over HTTPS:
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# add docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 

# set up the stable repository.
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install docker engine
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# log that this has been ran already
echo "docker" >> $ZSHAI_DATA/installs
