#!/bin/bash
#配置环境导入
source /etc/profile
#java环境导入
export JAVA_HOME=$JAVA_HOME

#服务名
AppName=admin.jar
# JVM参数
JVM_OPTS="-Dname=$AppName  -Duser.timezone=Asia/Shanghai -Xms512m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError -XX:+PrintGCDateStamps  -XX:+PrintGCDetails -XX:NewRatio=1 -XX:SurvivorRatio=30 -XX:+UseParallelGC -XX:+UseParallelOldGC"
PID=""
# shellcheck disable=SC2009
PID=$(ps -ef |grep java|grep $AppName|grep -v grep|awk '{print $2}')

if [ x"$1" = x"start" ];then
   if [ x"$PID" != x"" ]; then
                  kill "$PID"
                  echo "$AppName (pid:$PID) exiting..."
                  while [ x"$PID" != x"" ]
                  do
                          sleep 1
                  # shellcheck disable=SC2009
                  PID=$(ps -ef |grep java|grep $AppName|grep -v grep|awk '{print $2}')
                  done
                  echo "$AppName exited."
   fi
        nohup java "$JVM_OPTS" -jar $AppName > /dev/null 2>&1 &
        echo "Start $AppName success..."
elif [ x"$1" = x"stop" ];then
   if [ x"$PID" != x"" ]; then
          kill "$PID"
          echo "$AppName (pid:$PID) exiting..."
          while [ x"$PID" != x"" ]
          do
                  sleep 1
          # shellcheck disable=SC2009
          PID=$(ps -ef |grep java|grep $AppName|grep -v grep|awk '{print $2}')
          done
   fi
   echo "$AppName exited."
elif [ x"$1" = x"restart" ];then
   if [ x"$PID" = x"" ];
   then
       nohup java "$JVM_OPTS" -jar $AppName > /dev/null 2>&1 &
       echo "Start $AppName success..."
   else
      if [ x"$PID" != x"" ]; then
                     kill "$PID"
                     echo "$AppName (pid:$PID) exiting..."
                     while [ x"$PID" != x"" ]
                     do
                             sleep 1
                     # shellcheck disable=SC2009
                     PID=$(ps -ef |grep java|grep $AppName|grep -v grep|awk '{print $2}')
                     done
                     echo "$AppName exited."
       fi
           nohup java "$JVM_OPTS" -jar $AppName > /dev/null 2>&1 &
           echo "Start $AppName success..."

   fi
elif [ x"$1" = x"status" ];then
      if [ x"$PID" = x"" ];then

      echo "服务暂时未启动"
      elif [ x"PID" != x"" ];then
      	   echo "服务已经启动，启动pid=$PID"
      fi
else
   echo "请按指令对应用(例如启动:app.sh start)"
   echo "stop(停止服务)  start(启动服务)  restart(重启服务)  status(查看服务状态)"
fi
