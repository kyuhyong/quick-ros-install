#!/bin/bash -eu

# The BSD License
# Copyright (c) 2018 PickNik Consulting
# Copyright (c) 2014 OROCA and ROS Korea Users Group

#set -x

function usage {
    # Print out usage of this script.
    echo >&2 "usage: $0 [ROS distro (default: melodic)"
    echo >&2 "          [-h|--help] Print help message."
    exit 0
}

# Parse command line. If the number of argument differs from what is expected, call `usage` function.
OPT=`getopt -o h -l help -- $*`
if [ $# != 1 ]; then
    usage
fi
eval set -- $OPT
while [ -n "$1" ] ; do
    case $1 in
        -h|--help) usage ;;
        --) shift; break;;
        *) echo "Unknown option($1)"; usage;;
    esac
done

ROS_DISTRO=$1
ROS_DISTRO=${ROS_DISTRO:="melodic"}

version=`lsb_release -sc`
echo ""
echo "INSTALLING ROS USING quick_ros_install --------------------------------"
echo ""
echo "Checking the Ubuntu version $version"
case $version in
  "saucy" | "trusty" | "vivid" | "wily" | "xenial" | "bionic" | "focal" | "jammy")
  ;;
  *)
    echo "ERROR: This script will only work on Ubuntu Saucy(13.10) / Trusty(14.04) / Vivid / Wily / Xenial / Bionic / Focal / Foxy. Exit."
    exit 0
esac

releasenum=`grep DISTRIB_DESCRIPTION /etc/*-release | awk -F 'Ubuntu ' '{print $2}' | awk -F ' LTS' '{print $1}'`
if [ "$releasenum" = "14.04.2" ]
then
  echo "Your ubuntu version is $releasenum"
  echo "Intstall the libgl1-mesa-dev-lts-utopic package to solve the dependency issues for the ROS installation specifically on $relesenum"
  sudo apt-get install -y libgl1-mesa-dev-lts-utopic
else
  echo "Your ubuntu version is $releasenum"
fi

echo "Add the ROS repository"
if [ "$ROS_DISTRO" = "foxy" ] | [ "$ROS_DISTRO" = "humble" ];
then
  sudo apt-get update
  sudo apt-get install -y software-properties-common
  sudo add-apt-repository -y universe
  sudo apt-get install -y curl gnupg2 lsb-release build-essential
  sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
else
if [ ! -e /etc/apt/sources.list.d/ros-latest.list ]; 
then
  sudo sh -c "echo \"deb http://packages.ros.org/ros/ubuntu ${version} main\" > /etc/apt/sources.list.d/ros-latest.list"
  echo "Download the ROS keys"
  roskey=`apt-key list | grep "ROS Builder"` && true # make sure it returns true
  if [ -z "$roskey" ]; then
    echo "No ROS key, adding"
    #sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
    sudo apt install -y curl # if you haven't already installed curl
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
  fi
fi
fi

echo "Updating & upgrading all packages"
sudo apt-get update
sudo apt-get dist-upgrade -y

echo "Installing ROS $ROS_DISTRO"

# Support for Python 3 in Noetic
if [ "$ROS_DISTRO" = "noetic" ]
then
   sudo apt install -y \
	liburdfdom-tools \
	python3-rosdep \
	python3-rosinstall \
	python3-bloom \
	python3-rosclean \
	python3-wstool \
	python3-pip \
	python3-catkin-lint \
	python3-catkin-tools \
	python3-rosinstall \
	ros-$ROS_DISTRO-desktop-full
  echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
elif [ "$ROS_DISTRO" = "foxy" ] | [ "$ROS_DISTRO" = "humble" ];
then
  sudo apt-get install -y ros-$ROS_DISTRO-desktop \
  python3-argcomplete \
  python3-colcon-common-extensions \
  python3-rosdep python3-vcstool  \
  ros-dev-tools
  echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
else
   sudo apt install -y \
	liburdfdom-tools \
	python-rosdep \
	python-rosinstall \
	python-bloom \
	python-rosclean \
	python-wstool \
	python-pip \
	python-catkin-lint \
	python-catkin-tools \
	python-rosinstall \
  python-rosinstall-generator \
  build-essential \
	ros-$ROS_DISTRO-desktop-full
  echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
fi


# Only init if it has not already been done before
if [ ! -e /etc/ros/rosdep/sources.list.d/20-default.list ]; then
  sudo rosdep init
fi
rosdep update

echo "Done installing ROS $ROS_DISTRO"
echo "Please type in terminal : source ~/.bashrc"
exit 0