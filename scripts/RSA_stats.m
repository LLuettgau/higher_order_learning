    %script to run stats on RSA matrices for early vs late phase of second-order conditioning
    
    clear all; close all; clc
    
    stim = 1; % 1 = FOC, 2 = SOC
    roi = 1; %1 = bil Amygdala, 2 = OFC cluster
    
    cd '/.../rsa/RSA_matrices'; %set path to rsa matrices

    addpath(genpath('...')) %set path to Effect size toolbox (needs to be downloaded at: https://github.com/hhentschke/measures-of-effect-size-toolbox) 

    if stim == 1
       if roi == 1

           load('pearson_EL_template_corr_FOC_USminus_CSminus_bil_Amygdala_ROI.mat');
           USminus_CSminus = ds_ztrans;
           USminus_CSminus_1 = USminus_CSminus;
                     
           load('pearson_EL_template_corr_FOC_USplus_CSplus_bil_Amygdala_ROI.mat');
           USplus_CSplus = ds_ztrans;
           USplus_CSplus_1 = USplus_CSplus;
           
           load('pearson_EL_template_corr_FOC_USminus_CSnew_bil_Amygdala_ROI.mat');
           USminus_CSnew = ds_ztrans;
           USminus_CSnew_1 = USminus_CSnew;
           
           load('pearson_EL_template_corr_FOC_USplus_CSnew_bil_Amygdala_ROI.mat');
           USplus_CSnew = ds_ztrans;
           USplus_CSnew_1 = USplus_CSnew;
           
           avg_US_CSnew = (USminus_CSnew+USplus_CSnew)/2;
       
      elseif roi == 2
           load('pearson_EL_template_corr_FOC_USminus_CSminus_cross_session_OFC_cluster.mat');
           USminus_CSminus = ds_ztrans;
           
           load('pearson_EL_template_corr_FOC_USplus_CSplus_cross_session_OFC_cluster.mat');
           USplus_CSplus = ds_ztrans;
           
           load('pearson_EL_template_corr_FOC_USminus_CSnew_cross_session_OFC_cluster.mat');
           USminus_CSnew = ds_ztrans;
           
           load('pearson_EL_template_corr_FOC_USplus_CSnew_cross_session_OFC_cluster.mat');
           USplus_CSnew = ds_ztrans;
           
           avg_US_CSnew = (USminus_CSnew+USplus_CSnew)/2;     
           

       end
       
    else
       if roi == 1
           load('pearson_EL_template_corr_SOC_USminus_CSminus_bil_Amygdala_ROI.mat');
           USminus_CSminus = ds_ztrans;
           USminus_CSminus_2 = USminus_CSminus;

           load('pearson_EL_template_corr_SOC_USplus_CSplus_bil_Amygdala_ROI.mat');
           USplus_CSplus = ds_ztrans;
           USplus_CSplus_2 = USplus_CSplus;

           load('pearson_EL_template_corr_SOC_USminus_CSnew_bil_Amygdala_ROI.mat');
           USminus_CSnew = ds_ztrans;
           USminus_CSnew_2 = USminus_CSnew;

           load('pearson_EL_template_corr_SOC_USplus_CSnew_bil_Amygdala_ROI.mat');
           USplus_CSnew = ds_ztrans;
           USplus_CSnew_2 = USplus_CSnew;

           avg_US_CSnew = (USminus_CSnew+USplus_CSnew)/2;

       elseif roi == 2
           load('pearson_EL_template_corr_SOC_USminus_CSminus_cross_session_OFC_cluster.mat');
           USminus_CSminus = ds_ztrans;
           
           load('pearson_EL_template_corr_SOC_USplus_CSplus_cross_session_OFC_cluster.mat');
           USplus_CSplus = ds_ztrans;
           
           avg_US_CS = (USminus_CSminus+USplus_CSplus)/2;
           
           load('pearson_EL_template_corr_SOC_USminus_CSnew_cross_session_OFC_cluster.mat');
           USminus_CSnew = ds_ztrans;
           
           load('pearson_EL_template_corr_SOC_USplus_CSnew_cross_session_OFC_cluster.mat');
           USplus_CSnew = ds_ztrans;
           
           avg_US_CSnew = (USminus_CSnew+USplus_CSnew)/2;    
           
       end
    end
    
    %% CSminus - USminus
    %subtract CSn similarity
    USminus_CSminus_norm = USminus_CSminus-USminus_CSnew;
    mean(USminus_CSminus_norm)
    
    %average RSA
    avg_USminusCSminus = (USminus_CSminus_norm(:,1)+USminus_CSminus_norm(:,2))/2;
    
    [h,p,ci,stats] = ttest(avg_USminusCSminus,0)
    %effect size
    mes(avg_USminusCSminus,0,'U3_1') 


    [h,p,ci,stats] = ttest(USminus_CSminus_norm,0, 'tail', 'right')
    [h,p,ci,stats] = ttest(USminus_CSminus_norm(:,1),USminus_CSminus_norm(:,2), 'tail', 'left')
    
    %Cohen's d
    diff_USminus = USminus_CSminus_norm(:,1) - USminus_CSminus_norm(:,2);
    d = (mean(USminus_CSminus_norm(:,1)) - mean(USminus_CSminus_norm(:,2))) / std(diff_USminus)
    


    %% CSplus - USplus

    %subtract CSn similarity
    USplus_CSplus_norm = USplus_CSplus-USplus_CSnew;
    mean(USplus_CSplus_norm)    
    
    avg_USplusCSplus = (USplus_CSplus_norm(:,1)+USplus_CSplus_norm(:,2))/2;

    [h,p,ci,stats] = ttest(avg_USplusCSplus,0)
    %effect size
    mes(avg_USplusCSplus,0,'U3_1') 
       
    [h,p,ci,stats] = ttest(USplus_CSplus_norm,0, 'tail', 'right')
    [h,p,ci,stats] = ttest(USplus_CSplus_norm(:,1),USplus_CSplus_norm(:,2), 'tail', 'left')
  
    %Cohen's d
    diff_USplus = USplus_CSplus_norm(:,1) - USplus_CSplus_norm(:,2);
    d = (mean(USplus_CSplus_norm(:,1)) - mean(USplus_CSplus_norm(:,2))) / std(diff_USplus)
    

  %% prepare writing data to long format
%     cd /.../csv_data/
%     load('ids.mat')
%     
%     res_to_plot = [x res_to_plot];
%     
%     varNames = {'SubID', 'CS2minusUSminus_early', 'CS2minusUSminus_late', ...
%                 'CS2plusUSplus_early', 'CS2plusUSplus_late', ...
%                 'CS2nUSminus_early', 'CS2nUSminus_late', ...
%                 'CS2nUSplus_early', 'CS2nUSplus_late', ...
%                 'CS1minusUSminus_early', 'CS1minusUSminus_late', ...
%                 'CS1plusUSplus_early', 'CS1plusUSplus_late', ...
%                 'CS1nUSminus_early', 'CS1nUSminus_late', ...
%                 'CS1nUSplus_early', 'CS1nUSplus_late'};
%     
%     CS_l = array2table(res_to_plot,'VariableNames',varNames);
% 
% 
%     writetable(CS_l,'rsa.csv','Delimiter',',');
%     
%     
%     res_to_plot = [USminus_CSminus_2-USminus_CSnew_2 USplus_CSplus_2-USplus_CSnew_2 ...
%                    USminus_CSminus_1-USminus_CSnew_1 USplus_CSplus_1-USplus_CSnew_1];
%     
%     cd /.../csv_data/
%     load('ids.mat')
%     
%     res_to_plot = [x res_to_plot];
%     
%     varNames = {'SubID', 'CS2minusUSminus_early', 'CS2minusUSminus_late', ...
%                 'CS2plusUSplus_early', 'CS2plusUSplus_late', ...
%                 'CS1minusUSminus_early', 'CS1minusUSminus_late', ...
%                 'CS1plusUSplus_early', 'CS1plusUSplus_late'};
%     
%     CS_l = array2table(res_to_plot,'VariableNames',varNames);
% 
% 
%     writetable(CS_l,'rsa_norm.csv','Delimiter',',');
%     
% varNames = {'SubID', 'FOC', 'SOC', ...
%     'Decoding_low', 'Decoding_high','idx'};
% varNames = {'Decoding'};
% CS_l = array2table(blub2,'VariableNames',varNames);
% 
% writetable(CS_l,'decoding2.csv','Delimiter',',');
