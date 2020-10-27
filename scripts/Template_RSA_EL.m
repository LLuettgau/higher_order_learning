%run (ROI-based) early-late RSA on trial-by-trial estimates using CoSMoMVPA
%clear all; close all; clc
function []=Template_RSA_EL(k)

addpath(genpath('/gpfs/project/projects/bpsydm/md_home_luettgau/CoSMoMVPA-master/'))

%% mask (ROI)

masks = {'/bil_Amygdala_ROI.nii.gz', '/cross_session_OFC_cluster.nii.gz'};

%% Define data
analysis_type = k; %1-8, 1-4 FOC: minus, plus, new (US-/US+); 5-8 SOC: minus, plus, new (US-/US+)

if analysis_type == 1
   cd /gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_1/
elseif analysis_type == 2
   cd /gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_1/
elseif analysis_type == 3
   cd /gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_1/
elseif analysis_type == 4
   cd /gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_1/   
elseif analysis_type == 5
   cd /gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_1/
elseif analysis_type == 6
   cd /gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_1/
elseif analysis_type == 7
   cd /gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_1/ 
elseif analysis_type == 8
   cd /gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_1/    
end   
   
data = dir('9*.feat');
format compact 

n_masks=numel(masks);

%for analysis_type = 1:4 %1 to 4
    disp('running analysis:');
    disp(analysis_type);
for m = 1:n_masks
    msk = masks{m};

    for i = 1:length(data)
    i
        chunks = 1:2;

        for n = 1:size(chunks,2) %chunk count
            if n == 1
                j = 1:25;
            else
                j = 26:50;
            end
        
        %data paths of early (1-25)/late (26-50) trials of SOC
        if analysis_type == 1
            data_path_soc1=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(1))],data(i).name,'/stats');
            data_path_soc2=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(2))],data(i).name,'/stats');
            data_path_soc3=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(3))],data(i).name,'/stats');
            data_path_soc4=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(4))],data(i).name,'/stats');
            data_path_soc5=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(5))],data(i).name,'/stats');
            data_path_soc6=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(6))],data(i).name,'/stats');
            data_path_soc7=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(7))],data(i).name,'/stats');
            data_path_soc8=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(8))],data(i).name,'/stats');
            data_path_soc9=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(9))],data(i).name,'/stats');
            data_path_soc10=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(10))],data(i).name,'/stats');
            data_path_soc11=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(11))],data(i).name,'/stats');
            data_path_soc12=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(12))],data(i).name,'/stats');
            data_path_soc13=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(13))],data(i).name,'/stats');
            data_path_soc14=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(14))],data(i).name,'/stats');
            data_path_soc15=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(15))],data(i).name,'/stats');
            data_path_soc16=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(16))],data(i).name,'/stats');
            data_path_soc17=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(17))],data(i).name,'/stats');
            data_path_soc18=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(18))],data(i).name,'/stats');
            data_path_soc19=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(19))],data(i).name,'/stats');
            data_path_soc20=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(20))],data(i).name,'/stats');
            data_path_soc21=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(21))],data(i).name,'/stats');
            data_path_soc22=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(22))],data(i).name,'/stats');
            data_path_soc23=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(23))],data(i).name,'/stats');
            data_path_soc24=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(24))],data(i).name,'/stats');
            data_path_soc25=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSminus/trial_', num2str(j(25))],data(i).name,'/stats');
        elseif analysis_type == 2
            data_path_soc1=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(1))],data(i).name,'/stats');
            data_path_soc2=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(2))],data(i).name,'/stats');
            data_path_soc3=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(3))],data(i).name,'/stats');
            data_path_soc4=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(4))],data(i).name,'/stats');
            data_path_soc5=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(5))],data(i).name,'/stats');
            data_path_soc6=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(6))],data(i).name,'/stats');
            data_path_soc7=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(7))],data(i).name,'/stats');
            data_path_soc8=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(8))],data(i).name,'/stats');
            data_path_soc9=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(9))],data(i).name,'/stats');
            data_path_soc10=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(10))],data(i).name,'/stats');
            data_path_soc11=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(11))],data(i).name,'/stats');
            data_path_soc12=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(12))],data(i).name,'/stats');
            data_path_soc13=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(13))],data(i).name,'/stats');
            data_path_soc14=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(14))],data(i).name,'/stats');
            data_path_soc15=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(15))],data(i).name,'/stats');
            data_path_soc16=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(16))],data(i).name,'/stats');
            data_path_soc17=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(17))],data(i).name,'/stats');
            data_path_soc18=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(18))],data(i).name,'/stats');
            data_path_soc19=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(19))],data(i).name,'/stats');
            data_path_soc20=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(20))],data(i).name,'/stats');
            data_path_soc21=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(21))],data(i).name,'/stats');
            data_path_soc22=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(22))],data(i).name,'/stats');
            data_path_soc23=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(23))],data(i).name,'/stats');
            data_path_soc24=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(24))],data(i).name,'/stats');
            data_path_soc25=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSplus/trial_', num2str(j(25))],data(i).name,'/stats');
        elseif analysis_type == 3 
            data_path_soc1=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(1))],data(i).name,'/stats');
            data_path_soc2=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(2))],data(i).name,'/stats');
            data_path_soc3=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(3))],data(i).name,'/stats');
            data_path_soc4=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(4))],data(i).name,'/stats');
            data_path_soc5=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(5))],data(i).name,'/stats');
            data_path_soc6=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(6))],data(i).name,'/stats');
            data_path_soc7=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(7))],data(i).name,'/stats');
            data_path_soc8=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(8))],data(i).name,'/stats');
            data_path_soc9=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(9))],data(i).name,'/stats');
            data_path_soc10=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(10))],data(i).name,'/stats');
            data_path_soc11=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(11))],data(i).name,'/stats');
            data_path_soc12=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(12))],data(i).name,'/stats');
            data_path_soc13=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(13))],data(i).name,'/stats');
            data_path_soc14=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(14))],data(i).name,'/stats');
            data_path_soc15=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(15))],data(i).name,'/stats');
            data_path_soc16=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(16))],data(i).name,'/stats');
            data_path_soc17=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(17))],data(i).name,'/stats');
            data_path_soc18=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(18))],data(i).name,'/stats');
            data_path_soc19=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(19))],data(i).name,'/stats');
            data_path_soc20=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(20))],data(i).name,'/stats');
            data_path_soc21=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(21))],data(i).name,'/stats');
            data_path_soc22=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(22))],data(i).name,'/stats');
            data_path_soc23=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(23))],data(i).name,'/stats');
            data_path_soc24=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(24))],data(i).name,'/stats');
            data_path_soc25=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(25))],data(i).name,'/stats');
        elseif analysis_type == 4
            data_path_soc1=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(1))],data(i).name,'/stats');
            data_path_soc2=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(2))],data(i).name,'/stats');
            data_path_soc3=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(3))],data(i).name,'/stats');
            data_path_soc4=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(4))],data(i).name,'/stats');
            data_path_soc5=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(5))],data(i).name,'/stats');
            data_path_soc6=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(6))],data(i).name,'/stats');
            data_path_soc7=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(7))],data(i).name,'/stats');
            data_path_soc8=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(8))],data(i).name,'/stats');
            data_path_soc9=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(9))],data(i).name,'/stats');
            data_path_soc10=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(10))],data(i).name,'/stats');
            data_path_soc11=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(11))],data(i).name,'/stats');
            data_path_soc12=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(12))],data(i).name,'/stats');
            data_path_soc13=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(13))],data(i).name,'/stats');
            data_path_soc14=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(14))],data(i).name,'/stats');
            data_path_soc15=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(15))],data(i).name,'/stats');
            data_path_soc16=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(16))],data(i).name,'/stats');
            data_path_soc17=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(17))],data(i).name,'/stats');
            data_path_soc18=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(18))],data(i).name,'/stats');
            data_path_soc19=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(19))],data(i).name,'/stats');
            data_path_soc20=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(20))],data(i).name,'/stats');
            data_path_soc21=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(21))],data(i).name,'/stats');
            data_path_soc22=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(22))],data(i).name,'/stats');
            data_path_soc23=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(23))],data(i).name,'/stats');
            data_path_soc24=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(24))],data(i).name,'/stats');
            data_path_soc25=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/FOC/CSnew/trial_', num2str(j(25))],data(i).name,'/stats');
        elseif analysis_type == 5
            data_path_soc1=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(1))],data(i).name,'/stats');
            data_path_soc2=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(2))],data(i).name,'/stats');
            data_path_soc3=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(3))],data(i).name,'/stats');
            data_path_soc4=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(4))],data(i).name,'/stats');
            data_path_soc5=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(5))],data(i).name,'/stats');
            data_path_soc6=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(6))],data(i).name,'/stats');
            data_path_soc7=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(7))],data(i).name,'/stats');
            data_path_soc8=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(8))],data(i).name,'/stats');
            data_path_soc9=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(9))],data(i).name,'/stats');
            data_path_soc10=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(10))],data(i).name,'/stats');
            data_path_soc11=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(11))],data(i).name,'/stats');
            data_path_soc12=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(12))],data(i).name,'/stats');
            data_path_soc13=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(13))],data(i).name,'/stats');
            data_path_soc14=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(14))],data(i).name,'/stats');
            data_path_soc15=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(15))],data(i).name,'/stats');
            data_path_soc16=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(16))],data(i).name,'/stats');
            data_path_soc17=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(17))],data(i).name,'/stats');
            data_path_soc18=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(18))],data(i).name,'/stats');
            data_path_soc19=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(19))],data(i).name,'/stats');
            data_path_soc20=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(20))],data(i).name,'/stats');
            data_path_soc21=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(21))],data(i).name,'/stats');
            data_path_soc22=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(22))],data(i).name,'/stats');
            data_path_soc23=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(23))],data(i).name,'/stats');
            data_path_soc24=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(24))],data(i).name,'/stats');
            data_path_soc25=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSminus/trial_', num2str(j(25))],data(i).name,'/stats');
        elseif analysis_type == 6
            data_path_soc1=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(1))],data(i).name,'/stats');
            data_path_soc2=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(2))],data(i).name,'/stats');
            data_path_soc3=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(3))],data(i).name,'/stats');
            data_path_soc4=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(4))],data(i).name,'/stats');
            data_path_soc5=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(5))],data(i).name,'/stats');
            data_path_soc6=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(6))],data(i).name,'/stats');
            data_path_soc7=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(7))],data(i).name,'/stats');
            data_path_soc8=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(8))],data(i).name,'/stats');
            data_path_soc9=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(9))],data(i).name,'/stats');
            data_path_soc10=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(10))],data(i).name,'/stats');
            data_path_soc11=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(11))],data(i).name,'/stats');
            data_path_soc12=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(12))],data(i).name,'/stats');
            data_path_soc13=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(13))],data(i).name,'/stats');
            data_path_soc14=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(14))],data(i).name,'/stats');
            data_path_soc15=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(15))],data(i).name,'/stats');
            data_path_soc16=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(16))],data(i).name,'/stats');
            data_path_soc17=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(17))],data(i).name,'/stats');
            data_path_soc18=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(18))],data(i).name,'/stats');
            data_path_soc19=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(19))],data(i).name,'/stats');
            data_path_soc20=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(20))],data(i).name,'/stats');
            data_path_soc21=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(21))],data(i).name,'/stats');
            data_path_soc22=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(22))],data(i).name,'/stats');
            data_path_soc23=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(23))],data(i).name,'/stats');
            data_path_soc24=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(24))],data(i).name,'/stats');
            data_path_soc25=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSplus/trial_', num2str(j(25))],data(i).name,'/stats');
        elseif analysis_type == 7 
            data_path_soc1=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(1))],data(i).name,'/stats');
            data_path_soc2=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(2))],data(i).name,'/stats');
            data_path_soc3=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(3))],data(i).name,'/stats');
            data_path_soc4=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(4))],data(i).name,'/stats');
            data_path_soc5=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(5))],data(i).name,'/stats');
            data_path_soc6=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(6))],data(i).name,'/stats');
            data_path_soc7=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(7))],data(i).name,'/stats');
            data_path_soc8=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(8))],data(i).name,'/stats');
            data_path_soc9=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(9))],data(i).name,'/stats');
            data_path_soc10=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(10))],data(i).name,'/stats');
            data_path_soc11=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(11))],data(i).name,'/stats');
            data_path_soc12=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(12))],data(i).name,'/stats');
            data_path_soc13=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(13))],data(i).name,'/stats');
            data_path_soc14=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(14))],data(i).name,'/stats');
            data_path_soc15=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(15))],data(i).name,'/stats');
            data_path_soc16=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(16))],data(i).name,'/stats');
            data_path_soc17=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(17))],data(i).name,'/stats');
            data_path_soc18=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(18))],data(i).name,'/stats');
            data_path_soc19=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(19))],data(i).name,'/stats');
            data_path_soc20=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(20))],data(i).name,'/stats');
            data_path_soc21=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(21))],data(i).name,'/stats');
            data_path_soc22=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(22))],data(i).name,'/stats');
            data_path_soc23=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(23))],data(i).name,'/stats');
            data_path_soc24=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(24))],data(i).name,'/stats');
            data_path_soc25=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(25))],data(i).name,'/stats');
        elseif analysis_type == 8
            data_path_soc1=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(1))],data(i).name,'/stats');
            data_path_soc2=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(2))],data(i).name,'/stats');
            data_path_soc3=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(3))],data(i).name,'/stats');
            data_path_soc4=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(4))],data(i).name,'/stats');
            data_path_soc5=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(5))],data(i).name,'/stats');
            data_path_soc6=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(6))],data(i).name,'/stats');
            data_path_soc7=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(7))],data(i).name,'/stats');
            data_path_soc8=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(8))],data(i).name,'/stats');
            data_path_soc9=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(9))],data(i).name,'/stats');
            data_path_soc10=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(10))],data(i).name,'/stats');
            data_path_soc11=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(11))],data(i).name,'/stats');
            data_path_soc12=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(12))],data(i).name,'/stats');
            data_path_soc13=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(13))],data(i).name,'/stats');
            data_path_soc14=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(14))],data(i).name,'/stats');
            data_path_soc15=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(15))],data(i).name,'/stats');
            data_path_soc16=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(16))],data(i).name,'/stats');
            data_path_soc17=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(17))],data(i).name,'/stats');
            data_path_soc18=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(18))],data(i).name,'/stats');
            data_path_soc19=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(19))],data(i).name,'/stats');
            data_path_soc20=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(20))],data(i).name,'/stats');
            data_path_soc21=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(21))],data(i).name,'/stats');
            data_path_soc22=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(22))],data(i).name,'/stats');
            data_path_soc23=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(23))],data(i).name,'/stats');
            data_path_soc24=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(24))],data(i).name,'/stats');
            data_path_soc25=fullfile(['/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_lss/SOC/CSnew/trial_', num2str(j(25))],data(i).name,'/stats');
        end
        
        %classifier training experiment data paths
        data_path_loc1=fullfile('/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/run1/',data(i).name,'/stats');
        data_path_loc2=fullfile('/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/run2/',data(i).name,'/stats');
        data_path_loc3=fullfile('/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/run3/',data(i).name,'/stats');
        data_path_loc4=fullfile('/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/run4/',data(i).name,'/stats');
        data_path_loc5=fullfile('/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/run5/',data(i).name,'/stats');
           
        %mask path
        mask_path =fullfile('/gpfs/project/projects/bpsydm/md_scratch_luettgau/savage/classification/run1/',data(i).name,'/reg');
        
        %% SOC
        % Load the soc phase dataset 1 with mask
        ds_soc1 = cosmo_fmri_dataset([data_path_soc1 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc1=cosmo_remove_useless_data(ds_soc1);%static feature removal
        
        % Load the soc phase dataset 2 with mask
        ds_soc2 = cosmo_fmri_dataset([data_path_soc2 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc2=cosmo_remove_useless_data(ds_soc2);%static feature removal
        
        % Load the soc phase dataset 3 with mask
        ds_soc3 = cosmo_fmri_dataset([data_path_soc3 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc3=cosmo_remove_useless_data(ds_soc3);%static feature removal
        
        % Load the soc phase dataset 4 with mask
        ds_soc4 = cosmo_fmri_dataset([data_path_soc4 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc4=cosmo_remove_useless_data(ds_soc4);%static feature removal
        
        % Load the soc phase dataset 5 with mask
        ds_soc5 = cosmo_fmri_dataset([data_path_soc5 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc5=cosmo_remove_useless_data(ds_soc5);%static feature removal
        
        % Load the soc phase dataset 6 with mask
        ds_soc6 = cosmo_fmri_dataset([data_path_soc6 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc6=cosmo_remove_useless_data(ds_soc6);%static feature removal
        
        % Load the soc phase dataset 7 with mask
        ds_soc7 = cosmo_fmri_dataset([data_path_soc7 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc7=cosmo_remove_useless_data(ds_soc7);%static feature removal
        
        % Load the soc phase dataset 8 with mask
        ds_soc8 = cosmo_fmri_dataset([data_path_soc8 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc8=cosmo_remove_useless_data(ds_soc8);%static feature removal
        
        % Load the soc phase dataset 9 with mask
        ds_soc9 = cosmo_fmri_dataset([data_path_soc9 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc9=cosmo_remove_useless_data(ds_soc9);%static feature removal
        
        % Load the soc phase dataset 10 with mask
        ds_soc10 = cosmo_fmri_dataset([data_path_soc10 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc10=cosmo_remove_useless_data(ds_soc10);%static feature removal
        
        % Load the soc phase dataset 1 with mask
        ds_soc11 = cosmo_fmri_dataset([data_path_soc11 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc11=cosmo_remove_useless_data(ds_soc11);%static feature removal
        
        % Load the soc phase dataset 12 with mask
        ds_soc12 = cosmo_fmri_dataset([data_path_soc12 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc12=cosmo_remove_useless_data(ds_soc12);%static feature removal
        
        % Load the soc phase dataset 13 with mask
        ds_soc13 = cosmo_fmri_dataset([data_path_soc13 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc13=cosmo_remove_useless_data(ds_soc13);%static feature removal
        
        % Load the soc phase dataset 14 with mask
        ds_soc14 = cosmo_fmri_dataset([data_path_soc14 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc14=cosmo_remove_useless_data(ds_soc14);%static feature removal
        
        % Load the soc phase dataset 15 with mask
        ds_soc15 = cosmo_fmri_dataset([data_path_soc15 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc15=cosmo_remove_useless_data(ds_soc15);%static feature removal
        
        % Load the soc phase dataset 16 with mask
        ds_soc16 = cosmo_fmri_dataset([data_path_soc16 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc16=cosmo_remove_useless_data(ds_soc16);%static feature removal
        
        % Load the soc phase dataset 17 with mask
        ds_soc17 = cosmo_fmri_dataset([data_path_soc17 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc17=cosmo_remove_useless_data(ds_soc17);%static feature removal
        
        % Load the soc phase dataset 18 with mask
        ds_soc18 = cosmo_fmri_dataset([data_path_soc18 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc18=cosmo_remove_useless_data(ds_soc18);%static feature removal
        
        % Load the soc phase dataset 19 with mask
        ds_soc19 = cosmo_fmri_dataset([data_path_soc19 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc19=cosmo_remove_useless_data(ds_soc19);%static feature removal
        
        % Load the soc phase dataset 20 with mask
        ds_soc20 = cosmo_fmri_dataset([data_path_soc20 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc20=cosmo_remove_useless_data(ds_soc20);%static feature removal
        
        % Load the soc phase dataset 21 with mask
        ds_soc21 = cosmo_fmri_dataset([data_path_soc21 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc21=cosmo_remove_useless_data(ds_soc21);%static feature removal
        
        % Load the soc phase dataset 22 with mask
        ds_soc22 = cosmo_fmri_dataset([data_path_soc22 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc22=cosmo_remove_useless_data(ds_soc22);%static feature removal
        
        % Load the soc phase dataset 23 with mask
        ds_soc23 = cosmo_fmri_dataset([data_path_soc23 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc23=cosmo_remove_useless_data(ds_soc23);%static feature removal
        
        % Load the soc phase dataset 24 with mask
        ds_soc24 = cosmo_fmri_dataset([data_path_soc24 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc24=cosmo_remove_useless_data(ds_soc24);%static feature removal
        
        % Load the soc phase dataset 15 with mask
        ds_soc25 = cosmo_fmri_dataset([data_path_soc25 '/tstat1.nii.gz'], ...
            'mask', [mask_path msk]);
        ds_soc25=cosmo_remove_useless_data(ds_soc25);%static feature removal
        
        
        %% classifier trainign experiment (localizer)
        % Load the LOC quinine run1 dataset with mask
        ds_loc_q_run1 = cosmo_fmri_dataset([data_path_loc1 '/tstat1.nii.gz'], ...
            'mask', [mask_path, msk]);
        ds_loc_q_run1=cosmo_remove_useless_data(ds_loc_q_run1);%static feature removal
        
        % Load the LOC orange run1 dataset with mask
        ds_loc_o_run1 = cosmo_fmri_dataset([data_path_loc1 '/tstat2.nii.gz'], ...
            'mask', [mask_path, msk]);
        ds_loc_o_run1=cosmo_remove_useless_data(ds_loc_o_run1);%static feature removal
        
        % Load the LOC quinine run2 dataset with mask
        ds_loc_q_run2 = cosmo_fmri_dataset([data_path_loc2 '/tstat1.nii.gz'], ...
            'mask', [mask_path, msk]);
        ds_loc_q_run2=cosmo_remove_useless_data(ds_loc_q_run2);%static feature removal
        
        % Load the LOC orange run2 dataset with mask
        ds_loc_o_run2 = cosmo_fmri_dataset([data_path_loc2 '/tstat2.nii.gz'], ...
            'mask', [mask_path, msk]);
        ds_loc_o_run2=cosmo_remove_useless_data(ds_loc_o_run2);%static feature removal
        
        % Load the LOC quinine run3 dataset with mask
        ds_loc_q_run3 = cosmo_fmri_dataset([data_path_loc3 '/tstat1.nii.gz'], ...
            'mask', [mask_path, msk]);
        ds_loc_q_run3=cosmo_remove_useless_data(ds_loc_q_run3);%static feature removal
        
        % Load the LOC orange run3 dataset with mask
        ds_loc_o_run3 = cosmo_fmri_dataset([data_path_loc3 '/tstat2.nii.gz'], ...
            'mask', [mask_path, msk]);
        ds_loc_o_run3=cosmo_remove_useless_data(ds_loc_o_run3);%static feature removal
        
        % Load the LOC quinine run4 dataset with mask
        ds_loc_q_run4 = cosmo_fmri_dataset([data_path_loc4 '/tstat1.nii.gz'], ...
            'mask', [mask_path, msk]);
        ds_loc_q_run4=cosmo_remove_useless_data(ds_loc_q_run4);%static feature removal
        
        % Load the LOC orange run4 dataset with mask
        ds_loc_o_run4 = cosmo_fmri_dataset([data_path_loc4 '/tstat2.nii.gz'], ...
            'mask', [mask_path, msk]);
        ds_loc_o_run4=cosmo_remove_useless_data(ds_loc_o_run4);%static feature removal
        
        % Load the LOC quinine run5 dataset with mask
        ds_loc_q_run5 = cosmo_fmri_dataset([data_path_loc5 '/tstat1.nii.gz'], ...
            'mask', [mask_path, msk]);
        ds_loc_q_run5=cosmo_remove_useless_data(ds_loc_q_run5);%static feature removal
        
        % Load the LOC orange run5 dataset with mask
        ds_loc_o_run5 = cosmo_fmri_dataset([data_path_loc5 '/tstat2.nii.gz'], ...
            'mask', [mask_path, msk]);
        ds_loc_o_run5=cosmo_remove_useless_data(ds_loc_o_run5);%static feature removal

        
        %concatination of loc data sets to one ds and assign labels, chunks, targets
        ds_loc = cosmo_stack({ds_loc_q_run1,ds_loc_o_run1, ...
                              ds_loc_q_run2,ds_loc_o_run2, ...
                              ds_loc_q_run3,ds_loc_o_run3, ...
                              ds_loc_q_run4,ds_loc_o_run4, ...
                              ds_loc_q_run5,ds_loc_o_run5});

        ds_loc.sa.targets = repmat((1:2)',5,1);
        ds_loc.sa.chunks = ceil((1:10)'/2);
        labels = repmat({'quinine'; 'orange'},5,1);
        ds_loc.sa.labels = labels;
        avg_ds_loc = cosmo_fx(ds_loc, @(x)mean(x,1), 'targets', 1);  
    
    
        %analysis_type FOC: 1 = US- and CS-, 2= US+ and CS+, 3 = US- and CSn, 4 = US+ and CSn, 
        %SOC: 5 = US- and CS-, 6= US+ and CS+, 7 = US- and CSn, 8 = US+ and CSn, 
        if analysis_type == 2 || analysis_type == 4 || analysis_type == 6 || analysis_type == 8 %US+
           o_idx = avg_ds_loc.sa.targets == 2;
           avg_ds_loc = cosmo_slice(avg_ds_loc, o_idx);
        elseif analysis_type == 1 || analysis_type == 3 || analysis_type == 5 || analysis_type == 7 %US-
           q_idx = avg_ds_loc.sa.targets == 1;
           avg_ds_loc = cosmo_slice(avg_ds_loc, q_idx); 
        end

        %concatination of soc data sets to one ds and assign labels, chunks, targets
        ds_soc = cosmo_stack({ds_soc1, ds_soc2, ds_soc3, ds_soc4, ds_soc5, ...
                              ds_soc6, ds_soc7, ds_soc8, ds_soc9, ds_soc10, ...
                              ds_soc11, ds_soc12, ds_soc13, ds_soc14, ds_soc15, ...
                              ds_soc16, ds_soc17, ds_soc18, ds_soc19, ds_soc20, ...
                              ds_soc21, ds_soc22, ds_soc23, ds_soc24, ds_soc25});
                          
        %assign labels, chunks, targets to soc data set
        ds_soc.sa.targets = repmat(3,25,1);
        ds_soc.sa.chunks = repmat(2,25,1);
    
        if analysis_type == 1 || analysis_type == 5 
           labels_soc = repmat({'CS-'},25,1);
        elseif analysis_type == 2 || analysis_type == 6 
           labels_soc = repmat({'CS+'},25,1);
        elseif analysis_type == 3 || analysis_type == 4 || analysis_type == 7 || analysis_type == 8   
           labels_soc = repmat({'CSn'},25,1);
        end
        ds_soc.sa.labels = labels_soc;                  
                          
        avg_ds_soc = cosmo_fx(ds_soc, @(x)mean(x,1), 'targets', 1);  
        
        ds_soc = avg_ds_soc;

        %concatinate averaged loc and soc data sets
        ds = cosmo_stack({avg_ds_loc, ds_soc});
    
        %calculate representational dissimilarity
        ds_dsm(i,n) = pdist(ds.samples, 'correlation');

    end
    
    end

    %trun into representational similarity
    ds_corr = 1-ds_dsm;
    %arc tangential a.k.a. Fisher Z transformation
    ds_ztrans = atanh(ds_corr);

    
    %% save results
    cd /gpfs/project/projects/bpsydm/md_scratch_luettgau/savage/rsa/EL_template_rsa_no_ortho/

    %analysis_type FOC: 1 = US- and CS-, 2= US+ and CS+, 3 = US- and CSn, 4 = US+ and CSn, 
    %SOC: 5 = US- and CS-, 6= US+ and CS+, 7 = US- and CSn, 8 = US+ and CSn
   
    if analysis_type == 1%FOC CSminus
        save(['pearson_EL_template_corr_FOC_USminus_CSminus_', msk(2:end-7)],'ds_ztrans')
    elseif analysis_type == 2%FOC CSplus
        save(['pearson_EL_template_corr_FOC_USplus_CSplus_', msk(2:end-7)],'ds_ztrans')
    elseif analysis_type == 3%FOC US- CSnew
        save(['pearson_EL_template_corr_FOC_USminus_CSnew_', msk(2:end-7)],'ds_ztrans')
    elseif analysis_type == 4%FOC US+ CSnew
        save(['pearson_EL_template_corr_FOC_USplus_CSnew_', msk(2:end-7)],'ds_ztrans')
    elseif analysis_type == 5%SOC CSminus
        save(['pearson_EL_template_corr_SOC_USminus_CSminus_', msk(2:end-7)],'ds_ztrans')
    elseif analysis_type == 6%SOC CSplus
        save(['pearson_EL_template_corr_SOC_USplus_CSplus_', msk(2:end-7)],'ds_ztrans')
    elseif analysis_type == 7%SOC US- CSnew
        save(['pearson_EL_template_corr_SOC_USminus_CSnew_', msk(2:end-7)],'ds_ztrans')
    elseif analysis_type == 8%SOC US+ CSnew
        save(['pearson_EL_template_corr_SOC_USplus_CSnew_', msk(2:end-7)],'ds_ztrans')
    end
                
                


 
end            
end
    

    







