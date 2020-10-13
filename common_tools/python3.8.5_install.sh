yum -y update
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel libffi-devel gcc make
wget -P /home https://cdn.npm.taobao.org/dist/python/3.8.5/Python-3.8.5.tgz
cd /home && tar -zxvf Python-3.8.5.tgz
cd Python-3.8.5
mkdir /usr/local/python3.8.5
./configure --prefix=/usr/local/python3.8.5 
./configure --enable-optimizations  
make && make install
ln -s /usr/local/python3.8.5/bin/python3 /usr/bin/python3  
ln -s /usr/local/python3.8.5/bin/pip3 /usr/bin/pip3
python3 --version