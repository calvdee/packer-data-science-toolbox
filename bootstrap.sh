#!/usr/bin/env bash

USER=ubuntu
HOME=/home/$USER
REPOS=$HOME/repos
TOOLS=$HOME/tools
DOWNLOADS=$HOME/downloads

log () {
	echo "[data-science-toolbox] $1" | tee -a $HOME/bootstrap.log
}

mkdir -p $REPOS
mkdir -p $TOOLS
mkdir -p $DOWNLOADS

log 'Adding repos for node and R...'
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu precise/" >> /etc/apt/sources.list'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

log 'Retrieving updated list of packages...'
sudo apt-get update

log 'Installing common requirements...'
sudo apt-get install -y curl git python-pip make python-dev

log 'Installing scientific Python stack...'
sudo apt-get install -y python-numpy python-scipy python-matplotlib python-pandas python-scikits.learn
sudo pip install ipython

log 'Installing GNU parallel...'
cd $DOWNLOADS
wget http://ftp.gnu.org/gnu/parallel/parallel-latest.tar.bz2
tar -xjf parallel-latest.tar.bz2
cd $(find -name 'parallel-*' -type d)
./configure && make && sudo make install

log 'Installing jq...'
cd $TOOLS
wget http://stedolan.github.io/jq/download/linux64/jq
chmod +x jq

log 'Installing requirements for scrape...'
sudo apt-get install -y libxml2-dev libxslt1-dev 
sudo pip install cssselect lxml

log 'Cloning data-science-toolbox repository...'
cd $REPOS
git clone https://github.com/jeroenjanssens/data-science-toolbox.git

log 'Installing csvkit...'
sudo pip install csvkit

cd $HOME
log 'Installing json2csv...'
echo 'golang-go golang-go/dashboard boolean true' > preseed.conf
sudo debconf-set-selections preseed.conf
sudo apt-get install -y golang-go
sudo go get github.com/jehiah/json2csv

log 'Installing xml2json...'
sudo apt-get install -y python-software-properties python python-pip g++ make 
sudo apt-get install -y nodejs
curl https://npmjs.org/install.sh | sudo clean=yes sh
sudo npm install -g xml2json-command

log 'Installing R...'
sudo apt-get install -y r-base-dev

log 'Installing sqldf, ggplot2, and plyr packages'
echo 1 | sudo $REPOS/data-science-toolbox/tools/Rio -ve 'install.packages(c("sqldf","ggplot2","plyr"),repos="http://cran.us.r-project.org")'

log 'Installing s3cmd...'
sudo apt-get install -y s3cmd

log 'Installing httpie'
sudo apt-get install -y python-software-properties python python-pip
sudo pip install httpie

sudo echo 'export PATH=$PATH:/usr/lib/go/bin:/home/$USER/repos/data-science-toolbox/tools:/home/$USER/tools' >> $HOME/.bashrc 
sudo chown -R $USER:$USER $REPOS
sudo chown -R $USER:$USER $TOOLS
sudo rm -rf $DOWNLOADS
sudo rm -rf $HOME/tmp
sudo rm $HOME/preseed.conf

log 'Finished bootstrapping the Data Science Toolbox'

