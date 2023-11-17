#!/bin/bash -eu

#set -x

function usage {
    # Print out usage of this script.
    echo >&2 "usage: $0 [ROS distro : melodic, noetic, foxy]"
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

if [[ "$ROS_DISTRO" =~ ^(melodic|noetic|foxy)$ ]]; then
    echo "$ROS_DISTRO is in the list"
else
    echo "$ROS_DISTRO is not in the list"
    exit 0
fi

input="$HOME/.bashrc"
# REMOVE any line begin with 'source /opt/ros/'
REMOVE_WORDS="source /opt/"
sed -i '/^$REMOVE_WORDS/d' "$input"
echo "alias $ROS_DISTRO='echo \"ROS $ROS_DISTRO is activated!\"; \\" >> "$input"
echo "      source /opt/ros/$ROS_DISTRO/setup.bash'" >> "$input"
