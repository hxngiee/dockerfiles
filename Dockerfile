FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
ENV LC_ALL=C.UTF-8

# Install some basic utilities
RUN . /etc/os-release; \
		printf "deb http://ppa.launchpad.net/jonathonf/vim/ubuntu %s main" "$UBUNTU_CODENAME" main | tee /etc/apt/sources.list.d/vim-ppa.list && \
		printf "deb http://ppa.launchpad.net/git-core/ppa/ubuntu %s main" "$UBUNTU_CODENAME" main | tee /etc/apt/sources.list.d/git-ppa.list && \
		apt-key  adv --keyserver hkps://keyserver.ubuntu.com --recv-key 4AB0F789CBA31744CC7DA76A8CF63AD3F06FC659 && \
		apt-key  adv --keyserver hkps://keyserver.ubuntu.com --recv-key E1DD270288B4E6030699E45FA1715D88E1DF1F24 && \
		apt-get update && \
		env DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade --autoremove --purge --no-install-recommends -y \
			build-essential \
			bzip2 \
			ca-certificates \
			curl \
			git \
			graphviz \
			libcanberra-gtk-module \
			libgtk2.0-0 \
			libx11-6 \
			openssh-client \
			sudo \
			vim-nox \
			wget

# Create a working directory
RUN mkdir /app
WORKDIR /app

# Create a non-root user and switch to it
RUN adduser --disabled-password --gecos '' --shell /bin/bash user \
		&& chown -R user:user /app
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user
USER user

# All users can use /home/user as their home directory
ENV HOME=/home/user
ENV SHELL=/bin/bash


# Install Miniconda
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

ENV PATH=/home/user/miniconda3/bin:$PATH
ENV CONDA_AUTO_UPDATE_CONDA=false


# 안쓸거 같은 것들 주석처리해 놓음
# Create a Python 3.6 environment
#RUN /home/user/miniconda3/bin/conda update -n base -c defaults conda -y && \
# 		/home/user/miniconda3/bin/conda install conda-build -y \
#		&& /home/user/miniconda3/bin/conda create -y --name py36 python=3.6.5 \
#		&& /home/user/miniconda3/bin/conda clean -ya
#ENV CONDA_DEFAULT_ENV=py36
#ENV CONDA_PREFIX=/home/user/miniconda/envs/$CONDA_DEFAULT_ENV
#ENV PATH=$CONDA_PREFIX/bin:$PATH


# COPY requirements.txt /app/requirements.txt

# Install OpenCV, Jupyter Lab
# RUN pip install --no-cache-dir -r requirements.txt

