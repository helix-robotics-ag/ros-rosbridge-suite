ARG ROS_DISTRO=iron

FROM ros:${ROS_DISTRO}-ros-base AS builder

WORKDIR /colcon_ws

RUN git clone -b seb/custom_srv_for_holding_current https://github.com/helix-robotics-ag/ros-helix.git src/helix_ros && \
    . /opt/ros/${ROS_DISTRO}/setup.sh && \
    colcon build --packages-select helix_transmission_interfaces --cmake-args -DCMAKE_BUILD_TYPE=Release --event-handlers console_direct+



FROM ros:${ROS_DISTRO}-ros-core

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-rosbridge-suite \
    ros-${ROS_DISTRO}-tf2-msgs \
    ros-${ROS_DISTRO}-rosapi-msgs \
    ros-${ROS_DISTRO}-geometry-msgs \
    ros-${ROS_DISTRO}-sensor-msgs \
    ros-${ROS_DISTRO}-control-msgs \
    ros-${ROS_DISTRO}-controller-manager-msgs \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /colcon_ws/install/helix_transmission_interfaces /opt/ros/${ROS_DISTRO}

COPY ros_entrypoint.sh .

RUN echo 'source /opt/ros/iron/setup.bash; ros2 launch rosbridge_server rosbridge_websocket_launch.xml' >> /run.sh && chmod +x /run.sh
RUN echo 'alias run="su - ros --whitelist-environment=\"ROS_DOMAIN_ID\" /run.sh"' >> /etc/bash.bashrc
