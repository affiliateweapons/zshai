# disable nvidia services
sudo systemctl stop nvidia-hibernate
sudo systemctl disable nvidia-hibernate
sudo systemctl mask nvidia-hibernate

sudo systemctl stop nvidia-resume
sudo systemctl disable nvidia-resume
sudo systemctl mask nvidia-resume
