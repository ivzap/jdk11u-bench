#!/bin/bash
​
benchmarks=("batik" "avrora" "tradebeans"  "eclipse" "fop" "h2" "jython" "luindex" "lusearch" "lusearch-fix" "pmd" "sunflow" "tomcat" "tradesoap" "xalan")
java_path="${DAT_JDK}"
echo $java_path
for benchmark in "${benchmarks[@]}";
    do 
        sizes=$(dzdo $java_path -jar $DECAPO_PATH $benchmark --sizes 2>&1)
        size="default"
        if [[ $sizes =~ "huge" ]]; then
            size="huge"
        elif [[ $sizes =~ "large" ]]; then
            size="large"
        fi
        #filenameXY.txt where X and Y indicate the bitwise enable switches UseCustomReadBarrier and UseCustomWriteBarrier, respectively.
        echo "$benchmark $size benchmark is running"
        dzdo $java_path -XX:+UnlockExperimentalVMOptions -XX:+UseShenandoahGC -XX:-UseCustomReadBarrier -XX:-UseCustomWriteBarrier -jar $DECAPO_PATH $benchmark  &> "${benchmark}00.log" -s $size
        dzdo $java_path -XX:+UnlockExperimentalVMOptions -XX:+UseShenandoahGC -XX:-UseCustomReadBarrier -XX:+UseCustomReadBarrier -jar $DECAPO_PATH $benchmark  &> "${benchmark}01.log" -s $size
        dzdo $java_path -XX:+UnlockExperimentalVMOptions -XX:+UseShenandoahGC -XX:+UseCustomReadBarrier -XX:-UseCustomReadBarrier $DECAPO_PATH $benchmark  &> "${benchmark}10.log" -s $size
        dzdo $java_path -XX:+UnlockExperimentalVMOptions -XX:+UseShenandoahGC -XX:+UseCustomReadBarrier -XX:+UseCustomReadBarrier -jar $DECAPO_PATH $benchmark &> "${benchmark}11.log" -s $size
    done
