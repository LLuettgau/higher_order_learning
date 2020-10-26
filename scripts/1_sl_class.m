%run whole-brain searchlight analyses with permutation tests in savage data using CoSMoMVPA
%clear all; close all; clc

function []=sl_class(sub, type, cs_corr)

addpath(genpath('/gpfs/project/projects/bpsydm/md_home_luettgau/CoSMoMVPA-master/'))
cosmo_set_path()

mc_permu = 0;

correction = cs_corr; %subtract CSn pattern before?

%% mask (ROI, whole-brain)
msk = '/mask.nii.gz';

%nvoxels_per_searchlight = 100; %define searchlight content

output_path = '/gpfs/project/projects/bpsydm/md_scratch_luettgau/savage/classification/ds_sl/class_ica/';

%% analysis type
analysis_type = type; %1 = classify soc CS- and CS+ (subtract pattern of CSn before classification) based on learning on loc US- vs US+ template --> cross-session class
                   %2 = classify loc US- vs US+


%% Set the number of permutations
niter=100;

%% Define data
cd /gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_separate/


data = dir('9*.feat');
%data(19:20,:) = []; %dumb coding to exclude subject 925 and 926 (fell asleep during SOC)
format compact 

%for i = 1:length(data)
i = sub;

disp(i)
data(i).name


data_path_soc=fullfile('/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/soc_separate/',data(i).name,'/stats');

data_path_loc1=fullfile('/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/run1/',data(i).name,'/stats');
data_path_loc2=fullfile('/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/run2/',data(i).name,'/stats');
data_path_loc3=fullfile('/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/run3/',data(i).name,'/stats');
data_path_loc4=fullfile('/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/run4/',data(i).name,'/stats');
data_path_loc5=fullfile('/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/run5/',data(i).name,'/stats');

mask_path =fullfile('/gpfs/project/projects/bpsydm/md_home_luettgau/savage/fmri_analyses/analyses/classification_ica/run1/',data(i).name);


% Load the SOC (CS-) dataset with mask
ds_soc_q = cosmo_fmri_dataset([data_path_soc '/tstat1.nii.gz'], ...
                               'mask', [mask_path, msk]);

ds_soc_q=cosmo_remove_useless_data(ds_soc_q);%static feature removal

% Load the SOC (CS+) dataset with mask
ds_soc_o = cosmo_fmri_dataset([data_path_soc '/tstat2.nii.gz'], ...
                           'mask', [mask_path, msk]);
   
% Load the SOC (CSn) dataset with mask
ds_soc_n = cosmo_fmri_dataset([data_path_soc '/tstat3.nii.gz'], ...
                                   'mask', [mask_path, msk]);

ds_soc_n=cosmo_remove_useless_data(ds_soc_n);


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


%concatination of data sets to one ds                 
if analysis_type == 2
    ds_merged = cosmo_stack({ds_loc_q_run1,ds_loc_o_run1, ...
                             ds_loc_q_run2,ds_loc_o_run2, ...
                             ds_loc_q_run3,ds_loc_o_run3, ...
                             ds_loc_q_run4,ds_loc_o_run4, ... 
                             ds_loc_q_run5,ds_loc_o_run5});                  
                 
    ds_merged.sa.targets = repmat((1:2)',5,1);
    ds_merged.sa.chunks = ceil((1:10)'/2);

    labels = repmat({'quinine'; 'orange'},5,1);

    ds_merged.sa.labels = labels;

    ds = ds_merged;
    
else       
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

    
    %concatinate soc data sets and assign labels, chunks, targets
    ds_soc = cosmo_stack({ds_soc_q, ds_soc_o});
    ds_soc.sa.targets = [1;2];
    ds_soc.sa.chunks = [2; 2];
    %labels_soc = {'CS-'; 'CS+'};
    labels_soc = {'quinine'; 'orange'};
    ds_soc.sa.labels = labels_soc;

    if correction == 1
       %subtract CSn activation from soc
       ds_soc.samples(1,:) = ds_soc.samples(1,:) - ds_soc_n.samples;
       ds_soc.samples(2,:) = ds_soc.samples(2,:) - ds_soc_n.samples;
    end
    
    %concatinate averaged loc and soc data sets
    ds = cosmo_stack({avg_ds_loc, ds_soc});
    
end

% Define a spherical neighborhood with approximately
% 100 voxels around each voxel using cosmo_spherical_neighborhood,
% and assign the result to a variable named 'nbrhood'
%nbrhood=cosmo_spherical_neighborhood(ds,'count',nvoxels_per_searchlight, 'progress', false);
nbrhood=cosmo_spherical_neighborhood(ds,'radius',3, 'progress', false);

%define and customize partitions, train loc and test soc
partitions=cosmo_nfold_partitioner(ds);

if analysis_type < 4 || analysis_type > 4 
   partitions.train_indices=partitions.train_indices(1,2);
   partitions.test_indices=partitions.test_indices(1,2);
end
%define measure and measure arguments (partitioner, classifier)
measure=@cosmo_crossvalidation_measure;
measure_args.partitions=partitions;
measure_args.classifier=@cosmo_classify_svm;

%run classification searchlight
%ds_cfy=cosmo_searchlight(ds,nbrhood,measure,measure_args, 'progress', false);
ds_cfy=cosmo_searchlight(ds,nbrhood,measure,measure_args);


if analysis_type == 1 %corss-session classification
    output_fn=fullfile(output_path,'cross-session',[num2str(data(i).name(1:3)), '_sl_template_class_CSnsub_3mm.nii']);
end


if correction == 1
    if analysis_type == 2 %US+, US-
        output_fn=fullfile(output_path,'loc',[num2str(data(i).name(1:3)), '_sl_class_LOC_3mm.nii']);
    end

else
    if analysis_type == 2 %US+, US-
        output_fn=fullfile(output_path,'loc',[num2str(data(i).name(1:3)), '_sl_class_LOC_3mm.nii']);
    end

end

cosmo_map2fmri(ds_cfy, output_fn);

%% permutation searchlight maps

    if mc_permu == 1
        % null_data=zeros(niter,1); % allocate space for permuted accuracy maps
        ds0=ds; % make a copy of the dataset
        
        %specify partitioning scheme again
        partitions=cosmo_nfold_partitioner(ds0);
        
        if analysis_type < 4
           partitions.train_indices=partitions.train_indices(1,2);
           partitions.test_indices=partitions.test_indices(1,2);
        
        
           measure_args.partitions=partitions;
        %% for _niter_ iterations, reshuffle the labels and compute accuracy map
        % Use the helper function cosmo_randomize_targets
            for k=1:niter
                disp('running permutation:')
                disp(k)

                % generate randomized targets for training data (not for test!)
                x = [];
                x = [1 2]';
                x = x(randperm(length(x)));

                ds0.sa.targets(1:2)=x;

                %run classification searchlight on null data
                ds_cfy_null=cosmo_searchlight(ds0,nbrhood,measure,measure_args, 'progress', false);
                %null_data{k} = ds_cfy_null;

                %specifiy filename    
                output_fn_null=fullfile(output_path,'cross-session',['null_data', filesep, num2str(data(i).name(1:3)), '_', num2str(k),'_nulldata_sl_template_class_CSnsub_3mm.nii']);

                %save random map
                cosmo_map2fmri(ds_cfy_null, output_fn_null);

            end
        end
            
            
    end
end

