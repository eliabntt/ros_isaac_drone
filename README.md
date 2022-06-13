# ros_isaac_drone

download and install nlopt https://github.com/stevengj/nlopt.git

```
rosdep install --from-paths src --ignore-src -r -y	
sudo apt-get install liblapacke-dev
sudo apt install libdw-dev
```

build with `catkin build`
be sure to **FIRST BUILD** *moveit_core* and **THEN** source the env and THEN build everything else
