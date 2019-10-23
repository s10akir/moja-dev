FROM archlinux/base

MAINTAINER Akira Shinohara <k017c1067@it-neec.jp>


# install applications
RUN yes | pacman -Syyu
RUN yes | pacman -S tmux neovim git bat sudo zsh python python-pip fakeroot go tree
RUN echo -e "\nY" | pacman -Sy base-devel
RUN pip install neovim


# create User
RUN echo 's10akir ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/s10akir
RUN useradd -m -u 1000 s10akir

USER s10akir

# user setting
WORKDIR /home/s10akir

RUN git clone https://github.com/s10akir/dotfiles.git .dotfiles

# zsh
RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" 
RUN ln -s ~/.dotfiles/src/.zshrc
RUN ln -s ~/.dotfiles/src/.zshenv
RUN ln -s ~/.dotfiles/src/.zlogin
RUN ln -s ~/.dotfiles/src/.zlogout
RUN ln -s ~/.dotfiles/src/.zpreztorc
RUN ln -s ~/.dotfiles/src/.zprofile

# neovim
RUN mkdir -p .config/nvim
RUN ln -s ~/.dotfiles/src/.config/nvim/init.vim ~/.config/nvim/init.vim
RUN curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
RUN sh ./installer.sh ~/.cache/dein
RUN rm ./installer.sh

# etc...
RUN ln -s ~/.dotfiles/src/.tmux.conf

# yay
WORKDIR /tmp
RUN git clone https://aur.archlinux.org/yay.git
WORKDIR /tmp/yay
RUN makepkg
RUN yes | sudo pacman -U yay*.pkg.tar.xz

WORKDIR /home/s10akir
