%Run random-effects cluster statistics

function []=sl_class_stats_mc
addpath(genpath('/home/luettgau/CoSMoMVPA-master/'))

format compact

cd /home/luettgau/savage/fmri_analyses/analyses/classification_ica/run1/
data = dir('9*.feat');
%data(19:20,:) = []; %dumb coding to exclude subject 925 and 926 (fell asleep during SOC)


%after transforming data and mask to standard space using flirt
for i = 1:length(data)
     
    data_path=fullfile('/home/luettgau/scratch/savage/classification/ds_sl/class_ica/cross-session/standard_space/',data(i).name(1:3));
    mask_path =fullfile('/home/luettgau/savage/fmri_analyses/analyses/masks/classification');

    % Load the dataset with mask
    ds = cosmo_fmri_dataset([data_path '_smoothed_sl_template_class_CSnsub_3mm.nii.gz'], ...
                            'mask', [mask_path, '/standard_mask_all_thresh.nii.gz']);
    %concatinate  data sets
    ds_cell{i} = ds;

end

[idxs,ds_intersect_cell]=cosmo_mask_dim_intersect(ds_cell);

n_subjects=numel(ds_intersect_cell);
for subject_i=1:n_subjects
    % get dataset
    ds=ds_intersect_cell{subject_i};

    % store results
    ds_intersect_cell{subject_i}=ds;
end

%ds_all=cosmo_stack(ds_cell,1);
%ds_all=cosmo_stack(ds_intersect_cell,1,'drop_nonunique');
ds_all=cosmo_stack(ds_intersect_cell,1);

ds_all.sa.chunks=(1:n_subjects)';
ds_all.sa.targets=ones(n_subjects,1); 

%t-test, uncorrected for multiple comparisons
%subtract .5 (chance level) from ds.samples
ds_sub = ds_all;
ds_sub.samples = ds_sub.samples - .5;
stat_ds=cosmo_stat(ds_sub, 't', 'z');

thresh_mask = stat_ds.samples > 1.96;
thresh_stat_ds = stat_ds;
thresh_stat_ds.samples = thresh_stat_ds.samples .* thresh_mask;


% cosmo_plot_slices(thresh_stat_ds)
% 
% cd '/home/luettgau/scratch/savage/classification/ds_sl/class_ica/standard_space/';
% cosmo_map2fmri(stat_ds, 'smoothed_template_CSnsub_class_group_z.nii');

%%select searchlight classification null maps per subjects and
%%perform group-level permutation
%after transforming data and mask to standard space using flirt
cd '/home/luettgau/scratch/savage/classification/ds_sl/class_ica/cross-session/null_data/ds/3mm_ds/';
null_dists = dir('null*.mat');

for k = 1:length(null_dists)
    k
    load(null_dists(k).name)
        %concatinate  data sets
        null_ds_cell{k} = null_ds_all;

end


 %Define clustering neighborhood
 nh=cosmo_cluster_neighborhood(ds_all,'progress',false);
 %nh=cosmo_cluster_neighborhood(ds_all); 
 
 % Set options for monte carlo based clustering statistic
 opt=struct();
 opt.feature_stat = 'auto';
 %opt.cluster_stat = 'max'; %another way to implement multiple comparison correction
 %opt.p_uncorrected = .001; %set initial cluster-forming threshold only to
                            %be used without tfce
 opt.cluster_stat='tfce';  % Threshold-Free Cluster Enhancement;
                              % this is a (very reasonable) default
 opt.niter=50000;             % this is way too small except for testing;
                              % should usually be >=1000;
                              % better is >=10,000
 opt.h0_mean=0.5;            % test against chance level
 %opt.progress=false;       % do not show progress
 opt.dh=.001; % 0.01 for using accuracies 
 opt.null_data = null_ds_cell;
 %opt.nproc = 12;                              

 % Apply cluster-based correction
 % using cosmo_montecarlo_cluster_stat, compute a map with z-scores
 % against the null hypothesis of a mean of 0.5, corrected for multiple
 % comparisons.
tfce_z_ds=cosmo_montecarlo_cluster_stat(ds_all,nh,opt);
cd '/home/luettgau/scratch/savage/classification/ds_sl/class_ica/result_maps/';
cosmo_map2fmri(tfce_z_ds, 'tfce_wholebrain_50000_dh_001_z_template_CSnsub_class_3mm.nii');
