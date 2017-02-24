#! /bin/bash -u
# Command lines arguments are:
 # Platform files: platform_workflow-1ZGvD5_[max/av]_[a/]symmetric.xml
 #                  [AS/mock]_platform_workflow-1ZGvD5.xml
 # Deployment file: deployment_workflow-1ZGvD5.xml
 # Initial number particles: 100
 # Number of gate jobs: 100
 # SoS time: 300
 # Number of merge jobs: 1
 # CPU merge time: 0
 # Events per second: 0
 # version: 1 or 2

platform_type=${1:-"all"}

verbose=${2:-""}
 if [[ $verbose == "-v" ]]
 then
 	verbose="--log=root.fmt:[%12.6r]%e(%3i:%10P@%40h)%e%m%n"
 else
 	verbose="--log=jmsg.thres:critical"
 fi

version=2

cmd="java -cp ${VIPSIM}/bin:${SIMGRID_PATH}/simgrid.jar \
 VIPSimulator"
params="simgrid_files/deployment_workflow-1ZGvD5.xml \
 100 100 300 1 0 0 ${version} 10000000 ${verbose}"


case $platform_type in 
   "max_symmetric"|"max_asymmetric"|"avg_symmetric"|"avg_asymmetric" )
        platform_file="simgrid_files/platform_workflow-1ZGvD5_${platform_type}.xml"
        echo -e "\\tSimulate on ${platform_type}"
        run=$cmd" "${platform_file}" "${params}
        echo -e "\\t\\t$run"
        $run 1> timings/simulated_time_on_${platform_type}_v${version}.csv \
        2> csv_files/simulated_file_transfer_on_${platform_type}_v${version}.csv 
        ;;
   "AS"|"mock" )
        platform_file="simgrid_files/${platform_type}_platform_workflow-1ZGvD5.xml"
        echo -e "\\tSimulate on ${platform_type}"
        run=$cmd" "${platform_file}" "${params}
        echo -e "\\t\\t$run"
        $run 1> timings/simulated_time_on_${platform_type}_v${version}.csv \
        2> csv_files/simulated_file_transfer_on_${platform_type}_v${version}.csv
        ;;
   "all" )
        for platform_type in "max_symmetric" "max_asymmetric" "avg_symmetric" "avg_asymmetric"
        do
           platform_file="simgrid_files/platform_workflow-1ZGvD5_${platform_type}.xml"
           echo -e "\\tSimulate on ${platform_type}"
           run=$cmd" "${platform_file}" "${params}
           echo -e "\\t\\t$run"
           $run  1> timings/simulated_time_on_${platform_type}_v${version}.csv \
           2> csv_files/simulated_file_transfer_on_${platform_type}_v${version}.csv
        done
        for platform_type in "AS" "mock"
        do
           platform_file="simgrid_files/${platform_type}_platform_workflow-1ZGvD5.xml"
           echo -e "\\tSimulate on ${platform_type}"
           run=$cmd" "${platform_file}" "${params}
           echo -e "\\t\\t$run"
           $run  1> timings/simulated_time_on_${platform_type}_v${version}.csv \
           2> csv_files/simulated_file_transfer_on_${platform_type}_v${version}.csv
        done
        ;;
esac
version=3

if [ $platform_type == "AS" ]
then 
echo -e "\\tSimulate on AS  - version ${version}" 
platform_file="simgrid_files/AS_platform_workflow-1ZGvD5.xml"
run=$cmd" ${platform_file} simgrid_files/deployment_workflow-1ZGvD5_2.xml 100 100 300 1 0 0 ${version} 10000000 ${verbose}"
echo -e "\\t\\t$run"
$run  1> timings/simulated_time_on_AS_v${version}.csv \
      2> csv_files/simulated_file_transfer_on_AS_v${version}.csv
fi
