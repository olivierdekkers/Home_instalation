# Variables for installing VIM
_VIM_TARGET_VERSION=8.0
_WORKSPACE_DIR=$HOME/workspace
_VIM_SRC_DIR=$_WORKSPACE_DIR/vim

if [ "$VIM_VERSION" = "$_VIM_TARGET_VERSION" ]; then
    echo vim is currently at required version. Exitting.
    exit 0
fi

# Install required packages
sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git

# Remove previous vim installed
sudo apt-get remove vim vim-runtime gvim

# Creates the workspace directory
mkdir -p $_WORKSPACE_DIR 

# Repository fetch
if [ -d $_VIM_SRC_DIR ]; then
    cd $_VIM_SRC_DIR
    git pull
else
    git clone https://github.com/vim/vim.git $_VIM_SRC_DIR
fi

# Configure vim to build
# We need to know python config paths in order to build vim with python support
PYTHON3_CFG=`ls /usr/lib/python3.5 | grep config-`
PYTHON2_CFG=`ls /usr/lib/python2.7 | grep config-`

cd $_VIM_SRC_DIR; ./configure --with-features=huge \
    --enable-multibyte \
    --enable-rubyinterp=yes \
    --enable-pythoninterp=yes \
    --with-python-config-dir=/usr/lib/python2.7/$PYTHON2_CFG \
    --enable-python3interp=yes \
    --with-python3-config-dir=/usr/lib/python3.5/$PYTHON3_CFG \
    --enable-perlinterp=yes \
    --enable-luainterp=yes \
    --enable-gui=gtk2 --enable-cscope --prefix=/usr

# Building vim
make -C $_VIM_SRC_DIR VIMRUNTIMEDIR=/usr/share/vim/vim80	

# Installing built vim
sudo make -C $_VIM_SRC_DIR install

# Final setup
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
sudo update-alternatives --set editor /usr/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
sudo update-alternatives --set vi /usr/bin/vim
