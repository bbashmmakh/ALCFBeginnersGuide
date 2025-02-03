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


## Linaro DDT debugger





## A quick example


## References  
[User Guide for Intel Distribution for GDB](https://www.intel.com/content/www/us/en/docs/distribution-for-gdb/user-guide/2025-0/overview.html)  
[ALCF User Guide for gdb-oneapi](https://docs.alcf.anl.gov/aurora/debugging/gdb-oneapi/)   
[Linaro DDT User Guide](https://docs.linaroforge.com/24.1.1/html/forge/ddt/index.html)   
[ALCF User Guide for Linaro DDT](https://docs.alcf.anl.gov/aurora/debugging/ddt-aurora/)

# [NEXT ->](02_b_profiling.md)
