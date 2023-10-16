#https://www.r-bloggers.com/2022/08/installation-of-r-4-2-on-ubuntu-22-04-1-lts-and-tips-for-spatial-packages/
sudo apt -y purge r-base* r-recommended r-cran-*
sudo apt -y autoremove
sudo apt install -y --no-install-recommends software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

#https://launchpad.net/~c2d4u.team/+archive/ubuntu/c2d4u4.0+
sudo apt install -y r-base r-base-core r-recommended r-base-dev
sudo add-apt-repository -y ppa:c2d4u.team/c2d4u4.0+
sudo apt update
sudo apt install -y r-cran-lme4 r-cran-glmnet r-cran-meta 
