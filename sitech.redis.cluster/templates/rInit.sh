#!/bin/bash
#for meet redis nodes,replicate nodes,add slot to init a cluster.
#by xudong 2017-3-2
slotNum="{{slotnum}}"
#slot in all
declare -a mip
declare -a mport
#master ip/port info from reading configure file
declare -a sip
declare -a sport
#slave ip/port
#read ip/port from configure file

function get_addres()
{
 i=0
 for line in `cat configure.info`
 do
     mip[$i]=`echo $line |awk -F ':' '{ print $1 }'`
     mport[$i]=`echo $line|awk -F '-' '{ print $1 }'|awk -F ':' '{ print $2 }'`
     sip[$i]=`echo $line | awk -F '-' '{ print $2 }' | awk -F ':' '{ print $1 }'`
     sport[$i]=`echo $line |awk -F '-' '{ print $2 }' | awk -F ':' '{ print $2 }'`
     echo ${mip[$i]},${mport[$i]},${sip[$i]},${sport[$i]}
     let i=$i+1
 done
}

#meet redis nodes to the cluster
function cluster_meet()
{
 for (( i=0; i<${#sip[@]}; i++ ))  
 do
    echo "cluster meet ${sip[$i]}  ${sport[$i]} "| redis-cli -c -h ${mip[0]} -p ${mport[0]}
 done
 for (( i=1; i<${#mip[@]}; i++ ))
 do
    echo "cluster meet ${mip[$i]}  ${mport[$i]} "| redis-cli -c -h ${mip[0]} -p ${mport[0]}
 done
}

#replicate cluster nodes
function cluster_replicate()
{
 echo "" > master.node.list
 for (( i=0; i<${#mip[@]}; i++ ))
 do
   echo "cluster nodes"|redis-cli -c -h ${mip[$i]} -p ${mport[$i]}|grep -v grep|grep myself|grep master|cut -c -40 >> master.node.list
 done
 i=0
 for line in `cat master.node.list`
 do
 echo "cluster replicate $line "| redis-cli -c -h ${sip[$i]} -p ${sport[$i]}
 let i++
 sleep 3
 done
}

#add all slots to every nodes in cluster
function cluster_addslots()
{
 n=`cat  configure.info |wc -l`
 let n=$slotNum/n+1
 i=0
 m=0
 for line in `cat configure.info`
 do
     while(($i < $n))
     do
         let x=m*n+i
         if (($x > $slotNum));then
             break
         fi
         echo "cluster addslots $x "|  redis-cli -c -h ${mip[$m]}  -p ${mport[$m]} >> log.x
         let i++
     done
     let i=0
     let m++
 done
}

get_addres
echo "get addres over"

cluster_meet
echo "cluster meet over"

sleep 3

cluster_replicate
echo "replicate over"

cluster_addslots
echo "addres over"
