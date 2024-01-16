FROM ros:humble-ros-core-jammy as base
LABEL maintainer="Leonard Jung <jung340@purdue.edu>"

ENV ROS_DISTRO humble
ENV GAZEBO_VER garden


RUN <<EOF 
mkdir /root/workspace /root/workspace/src
mkdir /root/unitree/ /root/unitree/src
apt-get update && apt-get install --quiet -y \
python3-colcon-common-extensions \
build-essential \
libboost-all-dev \
net-tools \
libglib2.0-dev \
git
EOF

RUN <<LCM
cd /root/
git clone https://github.com/lcm-proj/lcm
cd lcm
mkdir build
cd build
cmake ..
make
make install
ldconfig
cd /root/
LCM

RUN <<unitree
. /opt/ros/humble/setup.sh
cd /root/unitree/src
git clone https://github.com/leonardjmihs/unitree_ros2_to_real
cd unitree_ros2_to_real
mv ros2_unitree_legged_msgs ..
git clone https://github.com/leonardjmihs/unitree_legged_sdk unitree_legged_sdk-master
cd unitree_legged_sdk-master
mkdir build
cd build
cmake ../
make
cd /root/unitree/
colcon build
unitree

WORKDIR /root/workspace
