# ros_isaac_drone

## This repository is part of the [GRADE](https://eliabntt.github.io/GRADE-RR/home) project

This is the repository containing the `catkin_ws` that has been used in the [GRADE]() project to control the robot during the dataset generation.

It will download automatically our [FUEL](https://github.com/HKUST-Aerial-Robotics/FUEL) fork ([here](https://github.com/eliabntt/FUEL/)), our custom [controller](https://github.com/eliabntt/custom_6dof_joint_controller) and the other necessary packages with the corresponding edits.

The main edits we did regard:
- modular topic names (all should be published to `/my_robot_x/...`)
- remove the dependence of FUEL to its own simulation. Therefore it can now work with Isaac Sim or any other simulation tools (e.g. Gazebo)
- tune some parameters

## Installation instructions

Download and install nlopt https://github.com/stevengj/nlopt.git

Create your catkin workspace and clone this repository `git clone git@github.com:eliabntt/ros_isaac_drone.git --recursive` 

Install dependencies:

```
sudo apt install libdw-dev
sudo apt-get install liblapacke-dev
rosdep install --from-paths src --ignore-src -r -y	
```

Build with `catkin build moveit_core && source ~/catkin_ws/devel/setup.bash && catkin build`

Be sure to **FIRST BUILD** *moveit_core* and **THEN** source the env and THEN build everything else

## Run instructions

For further instructions see the corresponding packages. 

In general the _placement_ can be run with `roslaunch collision_check collision_check.launch robot_mesh_path:=...`

The _exploration software_ can be run with `roslaunch exploration_manager my_exploration.launch box_min_x:=--- box_min_y:=--- box_min_z:=--- box_max_x:=--- box_max_y:=--- box_max_z:=--- mav_name:=---` --> will launch FUEL and the custom controller package.

To launch just the controller `roslaunch custom_joint_controller_ros publish_joint_commands_node.launch position_limit_x:=--- position_limit_y:=--- position_limit_z:=--- robot_id:=--- frame_id:=---`

__________
### CITATION
If you find this work useful please cite our work as

```
@misc{https://doi.org/10.48550/arxiv.2303.04466,
  doi = {10.48550/ARXIV.2303.04466},
  url = {https://arxiv.org/abs/2303.04466},
  author = {Bonetto, Elia and Xu, Chenghao and Ahmad, Aamir},
  keywords = {Robotics (cs.RO), FOS: Computer and information sciences, FOS: Computer and information sciences},
  title = {GRADE: Generating Realistic Animated Dynamic Environments for Robotics Research},
  publisher = {arXiv},
  year = {2023},
  copyright = {arXiv.org perpetual, non-exclusive license}
}
```
