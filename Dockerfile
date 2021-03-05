FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND noninteractive

# use bash shell as default
SHELL ["/bin/bash", "-c"]

ENV TZ=asia/kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# set some local environment variables
ENV LANG en_US.UTF-8

# install python, pip and pipenv
RUN apt-get update && \
    apt-get install -y sudo curl llvm git gcc make openssl wget net-tools libssl-dev libbz2-dev libreadline-dev libncurses5-dev libsqlite3-dev zlib1g-dev libffi-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev liblzma-dev


# add the user theja, tribute to https://en.wikipedia.org/wiki/theja0473/ubuntu18.04-python3.7.2
RUN useradd --create-home --no-log-init --system  theja && \
	echo "theja	ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
USER theja
WORKDIR /home/theja

# install pyenv for motoko
RUN curl https://pyenv.run | bash

# update path to use pyenv
ENV PATH ~/.pyenv/bin:~/.local/bin:$PATH

# set the bashrc (for interactive sessions) and bash_profile (for login sessions)
RUN echo "eval \"\$(pyenv init -)\"" > ~/.bashrc && \
    echo "eval \"\$(pyenv virtualenv-init -)\"" >> ~/.bashrc && \
	echo "eval \"\$(pyenv init -)\"" > ~/.bash_profile && \
    echo "eval \"\$(pyenv virtualenv-init -)\"" >> ~/.bash_profile
	
# use login bash shell as default from now on, so that the bash_profile is sourced before any RUN command
SHELL ["/bin/bash", "-lc"]

# install python 3.7.2, upgrade pip, and install pipenv
RUN pyenv update && \
	pyenv install 3.7.2 && \
	pyenv global 3.7.2 && \
	pip --no-cache-dir install --user --upgrade pip && \
	pip --no-cache-dir install --user --upgrade pipenv
