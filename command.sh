#download SPECjvm2008 installation package
wget https://www.spec.org/downloads/osg/java/SPECjvm2008_1_01_setup.jar

#install using command-line method
java -jar SPECjvm2008_1_01_setup.jar -i console

#install sar
sudo apt install sysstat

#remove sar.dat
#start sar, write the output to sar.dat and start SPECjvm2008
#stop sar
#analyze system activity data and output it to benchmark.txt
rm sar.dat;sar -o sar.dat 1 >/dev/null 2>&1 & java -jar SPECjvm2008.jar -ikv benchmark;killall sar;sar -A -f sar.dat > ./a1/benchmark.txt;

#clone pmu-tools
git clone https://github.com/andikleen/pmu-tools

#allow full access for non root
sudo sysctl -p 'kernel.perf_event_paranoid=-1'

#detect at level-1
../pmu-tools/toplev.py -l1 -v --no-desc java -jar SPECjvm2008.jar -ikv compress

#detect at level-2
../pmu-tools/toplev.py -l2 -v --no-desc java -jar SPECjvm2008.jar -ikv compress

#detect at level-3
../pmu-tools/toplev.py -l3 -v --no-desc java -jar SPECjvm2008.jar -ikv compress

#clone jenv
git clone https://github.com/jenv/jenv.git ~/.jenv

#add to PATH
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bash_profile

#restart shell
source ~/.bashrc

#add different JDK to jenv
jenv add /your/path/to/JDK/bin

#check if adding was successful
jenv versions

#change JDK
jenv global the_JDK_you_want_to_change

#update software package
sudo apt update

#install perf
sudo apt install linux-tools-common

#clone FlameGraph
git clone https://github.com/brendangregg/FlameGraph.git

#clone perf-map-agent
git clone https://github.com/jvm-profiling-tools/perf-map-agent.git 

#enter directory
cd perf-map-agent/

#compile
cmake .
make

#In order to associate FlameGraph with perf-map-agent, you need to open /FlameGraph/jmaps and modify Agent_HOME to your perf-map-agent/out directory

#run SPECjvm2008
java -jar SPECjvm2008.jar -ikv serial;

#find the PID of SPECjvm2008 in another shell
top

#collect data
perf stat -p PID

#get ready for the later FlameGraph
sudo perf record -F 99 -ag -p PID_of_SPECjvm2008 sleep 30;./FlameGraph/jmaps

#view perf.data
sudo perf report

#convert binary file to txt file
sudo perf script --header >perf.txt

#install sqlite
sudo apt install sqlite3

#create database
sqlite3 my.db

#create table
create table function(name varchar(100),number int,cycle bigint);

#import SQL file(in another shell)
sqlite3 my.db < function.sql;

#find the top ten functions with the highest number of runs
SELECT *
FROM function
ORDER BY number DESC
LIMIT 10;

#find the top ten functions with the highest cpu cycle of runs
SELECT *
FROM function
ORDER BY cycle DESC
LIMIT 10;

#get ready for the later FlameGraph(done)
sudo perf record -F 99 -ag -p PID_of_SPECjvm2008 sleep 30;
./FlameGraph/jmaps

# folding stack
sudo perf script > out.stacks

# generate svg
sudo cat out.stacks | ./FlameGraph/stackcollapse-perf.pl | grep -v cpu_idle | ./FlameGraph/flamegraph.pl --color=java --hash > out.svg