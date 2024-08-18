FROM osrf/ros:noetic-desktop-full-focal
#FROM amd64/ros:noetic-perception-focal
ARG DEBIAN_FRONTEND=noninteractive
ARG ROS_DISTRO=noetic

#
# install ORBSLAM3 ROS package
#

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        net-tools \
        vim \
        iputils-ping \
        git \
        build-essential \
        cmake \
        libeigen3-dev \
        ros-noetic-cv-bridge \
        ros-noetic-pointcloud-to-laserscan\
        ros-noetic-hector-trajectory-server \
        libboost-python-dev \
        python3 \
        python3-catkin-tools \
        libepoxy-dev\
        libopencv-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

WORKDIR /root

# RUN cd ~ && \
#     mkdir Dev && cd Dev &&\
#     git clone https://github.com/NiHe99/opencv.git &&\
#     cd opencv &&\
#     mkdir build &&\
#     cd build &&\
#     cmake -D CMAKE_BUILD_TYPE=Release -D WITH_CUDA=OFF -D CMAKE_INSTALL_PREFIX=/usr/local -DENABLE_PRECOMPILED_HEADERS=OFF .. &&\
#     make && \
#     sudo make install


RUN git clone https://github.com/stevenlovegrove/Pangolin.git && \
    cd Pangolin && \
    mkdir build && cd build && \
    cmake .. && \
    make && \
    make install

RUN mkdir -p catkin_ws/src && \
    cd catkin_ws/src && \
    git clone https://github.com/NiHe99/own_package.git && \     
    cd ..  

RUN cd catkin_ws/src && \
    git clone https://github.com/NiHe99/orb_slam3_ros.git && \
    cd .. && \
    catkin config \
      --extend /opt/ros/noetic && \
    catkin build -j 4

RUN echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc
