%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run this code for the calculation of depth for the light field 
% input: a ELSF format lenslet image with angular dimension 9x9 or any
% other odd angular dimension configurations : 5x5, 7x7 etc.
% please mex the file dcCluesEstimate_mex.cpp first before running the code
%
% output: dpOut1, which is the disparity in unit of pixels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

addpath(genpath('required'));

%% Read LF image from folder "testLF/"
% 1. The input LF image should be in lenselet format
LF_Remap= imread('testLF/ImTest2.jpg');

%% 2. Set LF angular dimension 
mParams.mAngDim= 9; % angular dimension, must be odd number
% disparity range and resolutions
% recommended setting: 
% For outputs from Lytro Illum: (3,101)
% For dataset with larger resolution such as HCI: (3,301)
mParams.dpRange= 3; % maximum disparity range [-mParams.dpRange,+mParams.dpRange]
mParams.dpRes = 101; % depth resolution

% calculate SP clues
spInfo= lfDepthSP(LF_Remap, mParams);


%================
%% Suggestion
% a. You can set up a breakpint here, and try out different cwParams 
% configurations for the best outputs. 
% b. You don't need to re-run the whole program to test different cwParams,
% since "lfDepthSP" is the most time consuming. 
% c. Just "play with" different cwParams, and run from here. You'll find he
% pattern after a few trys.
%================
% 3. setup WLS regularization parameters
% this first parameter alpha affects the output the most, 
% try different ones for the best result [0.0001, 0.1]. 
%  eg. ImTest1.png alpha=0.1; ImTest2.png alpha=0.1;
spInfo.cwParams.alpha= 0.1; 
spInfo.cwParams.Th_minEstVar= 0.2; % dp variation region supression threshold
spInfo.cwParams.occEdgeEnforce= 5;
% spInfo.cwParams.lcwEdgeEnforce= 2;
spInfo.cwParams.Th_lcwEdgEnforce= 0.1;
% spInfo.cwParams.Th_textureSupress= 0;

% final regularization
[dpOut1]= cwManipulate(spInfo); % figure;imshow(dpOut1,[]);
% dpOutput= (dpOut1- (spInfo.d_res-1)/2)*(2*spInfo.d_max/(spInfo.d_res-1));
% figure;imshow(dpOutput);
