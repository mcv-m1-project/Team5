clear all
close all
clc
addpath(genpath('.'))


set_type = 'train';
sprintf(set_type)
launch_w1
launch_w2_task3
%%

set_type = 'validate';
sprintf(set_type)
launch_w1
launch_w2_task3

set_type = 'test';
sprintf(set_type)
launch_w1
launch_w2_task3