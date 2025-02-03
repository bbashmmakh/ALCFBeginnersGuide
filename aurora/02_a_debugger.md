# Debugging on Aurora (WIP)

`gdb-oneapi` from Intel oneAPI software and `ddt` from Linaro are available to debug your applications on Intel Data Center Max 1550 GPUs on Aurora. 

### Users are assumed to know:
* Compilation of codes for Intel Data Center GPU Max cards
* Running the codes on Aurora compute nodes

### Learning Goals:
* How to run `gdb-oneapi` and `ddt` debuggers with your applications on Aurora


## Prelimimaries
To use debuggers, you need to compile and link your application with `-g`. To get anywhere with GPU debugging, the current best practice is to compile and link with `-g -O0`.

Before debugging your applications on Aurora, you must explicitly enable GPU debugging configurations on all the GPUs you are using, on all the nodes you are using. One way to do this is to create a script (`helper_toggle_eu_debug.sh`) and execute it across all your compute nodes using mpiexec. Here is an example script, which takes an argument 1 to enable debugging or 0 to disable it:


```bash 
#!/usr/bin/env bash
# helper_toggle_eu_debug.sh

export MY_RANK=${PMIX_RANK}
export MY_NODE=${PALS_NODEID}
export MY_LOCAL_RANK=${PALS_LOCAL_RANKID}

eu_debug_toggle() {
  for f in /sys/class/drm/card*/prelim_enable_eu_debug
  do
    echo $1 > $f
  done
  echo "INFO: EU debug state on rank-${MY_RANK}: $(cat /sys/class/drm/card*/prelim_enable_eu_debug | tr '\n' ' ')"
  # sleep 10
}

# One rank per node toggles eu debug:
if [ ${MY_LOCAL_RANK} -eq 0 ]; then
    eu_debug_toggle $1
fi
```

On an interactive job mode, issue the following before starting debugging:

```
export NNODES=`wc -l < $PBS_NODEFILE`
mpiexec -n $NNODES ./helper_toggle_eu_debug.sh 1
```

## Intel gdb-oneapi debugger

#### Loading a module for gdb-oneapi on Aurora
The default `oneapi` module includes `gdb-oneapi`, so no additional module is needed for `gdb-oneapi`.
```
$ module load oneapi 
$ gdb-oneapi --version
GNU gdb (Intel(R) Distribution for GDB* 2024.2.1) 14.2
Copyright (C) 2024 Free Software Foundation, Inc.; (C) 2024 Intel Corp.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
```


## Linaro DDT debugger
Linara DDT is a popular debugger to simplify the troubleshooting and optimization of complex, high-performance computing (HPC) applications. It excels in debugging parallel, multithreaded, and distributed applications written in C, C++, Fortran, and Python, and leverages an intuitive graphical interface that enables developers to easily identify bugs, memory leaks, and performance bottlenecks in individual threads or across thousands of processes on Aurora. 


#### Configuring the remote client



#### Loading a module for ddt on Aurora
Load the `forge` module on Aurora as follows:  
```
$ module load forge
$ ddt --version
Linaro DDT
Part of Linaro Forge.
Copyright (c) 2023-2024 Linaro Limited. All rights reserved.

Version: 24.1.1
Build ID: e662396d3e3eb309e231c793feaa7dc160ac4093
Review ID: Ifcf4812083c11d6b798d72e0857266c580b59867
Patchset ID: 1
Build Platform: centos linux 7.9 x86_64
Build Date: Dec 17 2024 23:45:12

Frontend OS: Linux
Nodes' OS: unknown
Last connected forge-backend: unknown
```


#### Running applications with ddt and connecting it to your client





## A quick example

### Build an example



### Debugging with `gdb-oneapi`



### Debugging with `ddt` 



## References  
[User Guide for Intel Distribution for GDB](https://www.intel.com/content/www/us/en/docs/distribution-for-gdb/user-guide/2025-0/overview.html)  
[ALCF User Guide for gdb-oneapi](https://docs.alcf.anl.gov/aurora/debugging/gdb-oneapi/)   
[Linaro DDT User Guide](https://docs.linaroforge.com/24.1.1/html/forge/ddt/index.html)   
[ALCF User Guide for Linaro DDT](https://docs.alcf.anl.gov/aurora/debugging/ddt-aurora/)

# [NEXT ->](02_b_profiling.md)
