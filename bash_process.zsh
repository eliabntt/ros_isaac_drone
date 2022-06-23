#!/bin/zsh
echo "Output folder: $1"
echo "Environment folder: $2"
echo "Tmp out folder: $3"
echo "Lower folder number: $4"
echo "Offset: $5"
echo "isaac folder: $6"
source ~/.zshrc
folder=$2/
availenv=($folder*)
folderlen=${#folder}
availenv=("${availenv[@]:$4:$5}")
screen -d -m -S ROSMASTER zsh -i -c "rostrue"

echo "WARNING! TMP OUT FOLDER WILL BE CLEARED FOR EACH EXPERIMENT"
echo "WARNING! we run rm ${3}/environment/* every time!!!"
echo "WARNING! we run mv ${3}/environment/ ${1}/ every time!!! Be aware!\n"

while true; do
    read -q "yn?Do you still wish to run this program (y/n)?"
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

sleep 5
for env in "${availenv[@]}"
do
	currentenv=${env:$folderlen}
	echo "Processing ${currentenv}"
	rm ${3}/${currentenv}/ -rf
	rm ${1}/${currentenv}/ -rf
	mkdir -p ${3}/${currentenv}
	screen -L -Logfile ${3}/${currentenv}/isaaclog.log -d -m -S ISAACSIM zsh -i -c "cd ${6} && ./python.sh standalone_examples/api/omni.isaac.ros_bridge/my_robot.py --/renderer/enabled='rtx,iray'  --config='/home/ebonetto/.local/share/ov/pkg/isaac_sim-2021.2.1/standalone_examples/api/omni.isaac.ros_bridge/config.yaml' --fix_env=${currentenv} && ./kill.sh"
	screen -L -Logfile ${3}/${currentenv}/rosbag.log -d -m -S ROSRECORDER zsh -i -c "rosbag record -a -O ${3}/${currentenv}/${currentenv}.bag --split --size=1024 -b 0"
	sleep 300
	result=1
	cnt=25000
	while [ $result -eq 1 ]
	do
		sleep 1
		screen -wipe > suppress_output
		if ! screen -list | grep -q "ISAACSIM"; then
			rm suppress_output
			result=0
			break
		fi
		((cnt=cnt-1))
		if [[ "$cnt" -eq 0 ]]; then
			for session in $(screen -ls); do screen -S "${session}" -X quit; done
			echo "ERROR had to manually stop the sessions" > ${3}/${currentenv}/error.txt
		fi
	done
	#screen -S ROSRECORDER -X stuff "^C"
	screen -d -m -S ISAACRM zsh -i -c "cd ${6} && rm kit/logs -rf"
	for session in $(screen -ls | grep -o '[0-9]*\.ROSRECORDER'); do screen -S "${session}" -X stuff "^C"; done
	screen -d -m -S mover zsh -i -c "mv ${3}/${currentenv} ${1}/"
	echo "Finished Processing ${currentenv}"
done
