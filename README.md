# Quick ROS Install

Instant install script for ROS on various versions of Ubuntu Linux

이 패키지는 다양한 우분투 리눅스에서 ROS를 한번에 설치하기 위한 스크립트입니다.  

- 우분투 18.04, ROS-melodic 버전에서 테스트되었습니다.  
- **ros-melodic-desktop-full** 버전이 설치됩니다.

이 프로젝트중 ros_install.sh는 다음 라이센스를 따릅니다.
[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)  
Copyright (c) 2014 OROCA and ROS Korea Users Group  
Copyright (c) 2018 PickNik Consulting  
Copyright (c) 2021 Kyuhyong You  

## ros 설치하기

ros-melodic 버전을 설치하는 경우 터미널에 다음과 같이 입력합니다.  

```
sudo ./ros_install.sh melodic
```
설치가 완료되면 재부팅을 권장합니다.  
참고로 roscore, turtlesim으로 테스트는 아래 catkin_install 수행 후 실행 바랍니다.  
2023.11.17현재 melodic, noetic 그리고 foxy 버전의 설치가 확인되었습니다.


## catkin_ws 설치 및 추가 패키지 설치

ROS 설치가 완료되면 터미널에 다음과 같이 입력하여 ws를 설치하고 등록합니다.  

이 스크립트는 sudo 명령으로 실행하면 안됩니다.  중간에 sudo 패스워드 입력을 요구하면 그때 입력합니다.

```
./catkin_install.sh
```
사용자의 home 디렉토리에 catkin_ws/src 디렉토리를 만듭니다.  
또한 모바일로봇 운용을 위한 네비게이션 패키지들을 자동으로 설치합니다.

## ros-ipset.sh

ros-ipset.sh 스크립트를 실행하면 ifconfig로 검색하여 export MATER_URI와 HOST_NAME IP를 자동으로 설정합니다.  
상기 catkin_install_r1.sh 혹은 catkin_install_r1mini.sh 를 설치하면 localhost 를 기본으로 등록합니다.

roscore를 자체 PC에서 구동하는 경우 그냥 ros-ipset.sh 를 실행하면 됩니다.
```
./ros-ipset.sh
```
원격의 MASTER IP로 연결하는 경우 해당 IP 주소를 입력합니다.  
MASTER주소가 192.168.1.1 인 경우
```
./ros-ipset.sh 192.168.1.1
```

## ros_bash_setup.sh

사용자의 .bashrc 파일에 alias설정을 추가하여 터미널에 ROS distro를 입력하여 설정하도록 합니다.
`noetic`을 사용하는 경우 터미널에 다음을 입력합니다.
```
./ros_bash_setup noetic
```
이제 터미널에 `noetic`을 입력하면 자동으로 `source /opt/ros/noetic/setup.bash`를 수행합니다.

  
---
