#!/bin/bash -x
#PBS -l select=2
#PBS -l walltime=01:00:00
#PBS -A alcf_training
#PBS -q aurorabootcamp
#PBS -k doe
#PBS -l daos=daos_user
#PBS -l filesystems=home:flare:daos_user

export http_proxy="http://proxy.alcf.anl.gov:3128"                                                                                                         export https_proxy="https://proxy.alcf.anl.gov:3128"

cd ${PBS_O_WORKDIR}
module use /soft/modulefiles
module load daos
DAOS_POOL=alcf_training # change to your allocated pool
DAOS_CONT=alcf_training_mnist_$USER
# Do the following on logging node if it is not created
daos cont destroy $DAOS_POOL $DAOS_CONT
daos cont create --type POSIX ${DAOS_POOL}  ${DAOS_CONT} --properties rd_fac:1
launch-dfuse.sh ${DAOS_POOL}:${DAOS_CONT}
mount|grep dfuse                                    #optional
ls /tmp/${DAOS_POOL}/${DAOS_CONT}                   #optional

# copy data
mkdir -p /tmp/${DAOS_POOL}/${DAOS_CONT}
cp -rvf /flare/alcf_training/hzheng/ALCFBeginnersGuide/aurora/examples/daos_example/2_mnist/data /tmp/${DAOS_POOL}/${DAOS_CONT}/data
ls /tmp/${DAOS_POOL}/${DAOS_CONT}/data*

NNODES=`cat $PBS_NODEFILE | uniq | wc -l`
RANKS_PER_NODE=12          # Number of MPI ranks per node
NRANKS=$(( NNODES * RANKS_PER_NODE ))
echo "NUM_OF_NODES=${NNODES}  TOTAL_NUM_RANKS=${NRANKS}  RANKS_PER_NODE=${RANKS_PER_NODE}"
CPU_BINDING1=list:4:9:14:19:20:25:56:61:66:71:74:79

module load frameworks
#LD_PRELOAD=/usr/lib64/libpil4dfs.so
mpiexec -np ${NRANKS} -ppn ${RANKS_PER_NODE} --cpu-bind ${CPU_BINDING1} --no-vni -genvall python3 ./test_mnist.py
ls /tmp/${DAOS_POOL}/${DAOS_CONT}/*

clean-dfuse.sh ${DAOS_POOL}:${DAOS_CONT}  
#daos cont destroy $DAOS_POOL $DAOS_CONT
exit 0
