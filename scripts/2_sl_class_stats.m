%Create chance level masks

function []=sl_class_stats(k)
addpath(genpath('/home/luettgau/CoSMoMVPA-master/'))

format compact

cd /home/luettgau/savage/fmri_analyses/analyses/classification_ica/run1/
data = dir('9*.feat');


%%
%select searchlight classification null maps per subjects and
%perform group-level permutation
%after transforming data and mask to standard space using flirt

% for k = 1:100

disp('null map no.')
    k
    for i = 1:length(data)

        null_data_path=fullfile('/home/luettgau/scratch/savage/classification/ds_sl/class_ica/cross-session/null_data/standard_space/',data(i).name(1:3));
        %mask_path=fullfile('/home/luettgau/savage/fmri_analyses/analyses/classification_ica/run1/',data(i).name);%regular whole-brain analysis
        mask_path =fullfile('/home/luettgau/savage/fmri_analyses/analyses/masks/classification');%ROI analysis
        % Load the k-th dataset of each subject with mask

        null_ds = cosmo_fmri_dataset([null_data_path, '_', num2str(k), '_smoothed_nulldata_sl_template_class_CSnsub_3mm.nii.gz'], ...
                            'mask', [mask_path, '/neurosynth_ROI.nii.gz']);%Neurosynth ROI         
        %null_ds = cosmo_fmri_dataset([null_data_path, '_', num2str(k), '_smoothed_nulldata_sl_template_class_CSnsub_3mm.nii.gz'], ...
        %                    'mask', [mask_path, '/L_OFC_ROI.nii.gz']);%Anatomical ROI   
        %null_ds = cosmo_fmri_dataset([null_data_path, '_', num2str(k), '_smoothed_nulldata_sl_template_class_CSnsub_3mm.nii.gz'], ...
        %                    'mask', [mask_path, '/Benz_et_al_taste_ROI.nii.gz']);%Benz et al. ROI  
        
        %concatinate  data sets
        null_ds_cell{i} = null_ds;

    end


    [nullidxs,null_ds_intersect_cell]=cosmo_mask_dim_intersect(null_ds_cell);

    n_subjects=numel(null_ds_intersect_cell);
    for subject_i=1:n_subjects
        % get dataset
        null_ds=null_ds_intersect_cell{subject_i};

        % assign chunks
        n_samples=size(null_ds.samples,1);
        null_ds.sa.chunks=ones(n_samples,1)*subject_i;

        %assign targets
        null_ds.sa.targets=1;

        % store results
        null_ds_intersect_cell{subject_i}=null_ds;
    end
%stack null datasets to 1x100 cell structure    
null_ds_all=cosmo_stack(null_ds_intersect_cell,1);


% save null_ds_all
cd '/home/luettgau/scratch/savage/classification/ds_sl/class_ica/cross-session/null_data/ds/3mm_ds/';
save(['neurosynth_mask_null_ds_all_',num2str(k)],'null_ds_all')
%save(['left_ofc_mask_null_ds_all_',num2str(k)],'null_ds_all')
%save(['karsta_mask_null_ds_all_',num2str(k)],'null_ds_all')


