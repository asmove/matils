# matils

This repository contains math open-code tools on MatLab

If the reader is already familiar with github, skip the next steps. To clone this repository, type the following commands on linux:

```
mkdir ~/matils
cd ~/mattls
git clone https://github.com/asmove/matils
```

In case the reader uses Windows, the current author recommends either the Git Bash or Tortoise Git as source management software. Git bash, although it is a terminal, the copy-paste of above commands works the same manner as for linux terminal.

# Installation

 If you wish to use it, follow the instructions:

1) Open Matlab up to the version 2015x, x = a, b;
2) Before calling the functions, type on MATLAB shell 

```
addpath('$MATILS')
addpath(genpath('$MATILS'))
savepath
``` 

where ```$MATILS``` stands for the path where you cloned the repository, ```addpath``` add the provided path to ```MATLABPATH``` and ```genpath``` generate all paths of subfolders within ```$MATILS```. If the reader followed the steps from previous section, the ```$MATILS``` corresponds to ```~/matils```.
