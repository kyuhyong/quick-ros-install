mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/
catkin_make
echo -e "\033[31m"Catkin workspace is created"\033[0m"

echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc

echo "Now install ROS packages for mobile robot"
sudo apt install -y ros-melodic-tf ros-melodic-joy \
 ros-melodic-teleop-twist-joy \
 ros-melodic-teleop-twist-keyboard \
 ros-melodic-laser-proc ros-melodic-rgbd-launch \
 ros-melodic-depthimage-to-laserscan \
 ros-melodic-rosserial-arduino ros-melodic-rosserial-python \
 ros-melodic-rosserial-server ros-melodic-rosserial-client \
 ros-melodic-rosserial-msgs ros-melodic-amcl \
 ros-melodic-map-server ros-melodic-move-base \
 ros-melodic-urdf ros-melodic-xacro ros-melodic-usb-cam \
 ros-melodic-compressed-image-transport \
 ros-melodic-rqt-image-view ros-melodic-gmapping \
 ros-melodic-navigation ros-melodic-interactive-markers \
 ros-melodic-ar-track-alvar ros-melodic-ar-track-alvar-msgs \
 ros-melodic-cartographer-ros \
 openssh-server \
 net-tools
echo -e "\033[31m"extra ros package installation is done"\033[0m"

sudo rosdep fix-permissions
rosdep update
echo -e "\033[31m"rosdep permission is changed"\033[0m"