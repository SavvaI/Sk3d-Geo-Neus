FROM nvidia/cuda:11.6.0-cudnn8-devel-ubuntu18.04
SHELL ["/bin/bash", "--login", "-c"]
RUN echo "$SHELL" 
RUN apt-get update
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y vim wget git tmux psmisc
WORKDIR /root
RUN wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh
RUN bash Anaconda3-2021.11-Linux-x86_64.sh -b -p /root/anaconda3
ENV PATH=/root/anaconda3/bin:$PATH

RUN echo "$SHELL" 
RUN conda init bash &&  . /root/.bashrc && conda install -y pytorch==1.11.0 torchvision==0.12.0 cudatoolkit=11.3 -c pytorch && conda install -y -c conda-forge fvcore iopath && conda install -y -c bottler nvidiacub && conda install -y pytorch3d -c pytorch3d
RUN git clone https://github.com/GhiXu/Geo-Neus /root/Geo-Neus
WORKDIR /root/Geo-Neus
RUN sed -i 's/open3d==0.9.0/open3d/g' requirements.txt
RUN pip install -r requirements.txt
RUN pip install pathlib
COPY . /root/Geo-Neus/
RUN mkdir /root/Geo-Neus/data
RUN pip install tensorboard
RUN sed -i "s:    data_dir = /mnt/D/hust_fu/Data/CASE_NAME:    data_dir = /root/Geo-Neus/data/CASE_NAME:g" ./confs/womask.conf
