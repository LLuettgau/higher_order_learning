%Analysis script for behavioral data of Luettgau, Porcu, Tempelmann, Jocham

clc; clear all; close all;

sample = 3; %set path to exp1 (behav) == 1 or exp2 (fmri) == 2, or all == 3 here

data_path = '/Users/lennart/Desktop/savage/github/behavioral_data/'; %set behavioral data path
%data_path = '...';

addpath(genpath('/Users/lennart/Desktop/Toolboxes/')) %set path to Effect size toolbox (needs to be downloaded at: https://github.com/hhentschke/measures-of-effect-size-toolbox)
%addpath(genpath('...')) %set path to Effect size toolbox (needs to be downloaded at: https://github.com/hhentschke/measures-of-effect-size-toolbox) 
%and Binomial test (https://www.mathworks.com/matlabcentral/fileexchange/24813-mybinomtest-s-n-p-sided)

exclude = [905; 925; 926]; %pilot and participiants who fell asleep during SOC...

cd(data_path)

if sample == 1 %behav
   data = dir('savage2LOG_*.mat');
   %load info on explicit knowlegde
   knowledge = xlsread('/Users/lennart/Desktop/savage/github/exp_knowledge.xlsx');
   %knowledge = xlsread('/.../exp_knowledge.xlsx');
   knowledge = knowledge(1:20,:);
elseif sample == 2 %fmri
   data = dir('savage_fmriLOG_9*.mat');
   %load info on explicit knowlegde
   knowledge = xlsread('/Users/lennart/Desktop/savage/github/exp_knowledge.xlsx');
   %knowledge = xlsread('/.../exp_knowledge.xlsx');
   knowledge = knowledge(21:end,:);
   %load US temperatures
   temperature = xlsread('/Users/lennart/Desktop/savage/github/temperature.xlsx');
elseif sample == 3 %all
   data1 = dir('savage2LOG_*.mat');
   data2 = dir('savage_fmriLOG_9*.mat');
   data = [data1; data2];
   %load info on explicit knowlegde
   knowledge = xlsread('/Users/lennart/Desktop/savage/github/exp_knowledge.xlsx');
   %knowledge = xlsread('/.../exp_knowledge.xlsx');
   %load US temperatures
   temperature = xlsread('/Users/lennart/Desktop/savage/github/temperature.xlsx');
   %knowledge = xlsread('/.../temperature.xlsx');
   
   %load OFC cluster
   ofc_cluster = load('/Users/lennart/Desktop/savage/github/roi/cluster_165_ofc.mat'); 
   %ofc_cluster = load('/.../roi/cluster_165_ofc.mat'); 
   ofc_cluster = ofc_cluster.avg_ds;
   ofc_cluster = [zeros(20,1); ofc_cluster];
   %load ppi (CS+ vs CS-) mOFC cluster
   %mofc_cluster = load('/Users/lennart/Desktop/savage/roi/mOFC_conn_meants.txt'); 
   mofc_cluster = load('/Users/lennart/Desktop/savage/github/roi/mOFC_only_conn_meants.txt'); 
   %mofc_cluster = load('/.../roi/mOFC_only_conn_meants.txt'); 
   %load choice data
   load('/Users/lennart/Desktop/savage/github/choice_bias.mat');
   %load('/.../choice_bias.mat');
   %bias yes/no
   index=choice_bias(:,2);
   %participants showing second order bias
   index(index>.5) = 1;
   %participants showing no second order bias
   index(index<.5) = 0;
   
   %FOC bias yes/no
   foc_index=choice_bias(:,1);
   %participants showing first order bias
   foc_index(foc_index>.5) = 1;
   %participants showing no first order bias
   foc_index(foc_index<.5) = 0;
   
   
   load('/Users/lennart/Desktop/savage/github/x.mat');
   decoding = x;
   decoding(:,4) = index;
   index = [zeros(20,1); index];
end

format compact

long_CS = [];

k = 1;

for i = 1:length(data)
    %load data set
    ds = load(data(i).name);
    
    %write out subID
    if isfield(ds,'savage2')
        name = ds.savage2.infoP;
    else
        name = ds.savage_fmri.infoP;
        load(['savage_fmri_preLOG_',num2str(name),'.mat'])
        load(['savage_fmri_postLOG_',num2str(name),'.mat'])
        load(['savage_classifierLOG_',num2str(name),'.mat'])

    end
    
    results(i,1) = name;
    
    results_kanji(i,1) = name;
    
    %rating data from classifier training experiment
    if sample == 2      
        
        results_classifier(i,1) = name;
        payout_corr(i,1) = savage_classifier.payout;
        probe_trials = savage_classifier.class(:,23) ~= 0;
        payout_corr(i,2) = sum(savage_classifier.class(:,23))/length(savage_classifier.class(probe_trials,23));
        
        %classifier ratings
        
        %US ratings pre
        [~, pos_min] = find(savage_classifier.preRatingFoodcues(6,:)==1);
        [~, pos_max] = find(savage_classifier.preRatingFoodcues(6,:)==2);
        
        %valence
        results_classifier(i,2) = savage_classifier.preRatingFoodcues(2,pos_min);%US-
        results_classifier(i,4) = savage_classifier.preRatingFoodcues(2,pos_max);%US+
        
        %intensity
        results_classifier(i,6) = savage_classifier.preRatingFoodcues(4,pos_min);%US-
        results_classifier(i,8) = savage_classifier.preRatingFoodcues(4,pos_max);%US+
        
        %US ratings post
        pos_max = [];
        pos_min = [];
        
        [~, pos_min] = find(savage_classifier.postRatingFoodcues(6,:)==1);
        [~, pos_max] = find(savage_classifier.postRatingFoodcues(6,:)==2);
        
        
        %valence
        results_classifier(i,3) = savage_classifier.postRatingFoodcues(2,pos_min);%US-
        results_classifier(i,5) = savage_classifier.postRatingFoodcues(2,pos_max);%US+
        
        %intensity
        results_classifier(i,7) = savage_classifier.postRatingFoodcues(4,pos_min);%US-
        results_classifier(i,9) = savage_classifier.postRatingFoodcues(4,pos_max);%US+
        
    end
    
    %general preparations, preparation of choice data
    if isfield(ds,'savage2')
        
        %delete NaNs from responses (fractals) - misses
        posnan = find(isnan(ds.savage2.forcedchoicefractals(:,12)));
        forcedchoicefractals = ds.savage2.forcedchoicefractals;
        forcedchoicefractals(posnan,:) = [];
        
        %delete NaNs from responses (kanjis) - misses
        posnankanjis = find(isnan(ds.savage2.forcedchoicekanjis(:,12)));
        forcedchoicekanjis = ds.savage2.forcedchoicekanjis;
        forcedchoicekanjis(posnankanjis,:) = [];
        
    else
        %delete NaNs from responses (fractals) - misses
        posnan = find(isnan(ds.savage_fmri.forcedchoicefractals(:,12)));
        forcedchoicefractals = ds.savage_fmri.forcedchoicefractals;
        forcedchoicefractals(posnan,:) = [];
        
        %delete NaNs from responses (kanjis) - misses
        posnankanjis = find(isnan(ds.savage_fmri.forcedchoicekanjis(:,12)));
        forcedchoicekanjis = ds.savage_fmri.forcedchoicekanjis;
        forcedchoicekanjis(posnankanjis,:) = [];
    end
    
    
    %% FOC/SOC attentional control performance
    if isfield(ds,'savage2')
       foc_perf(i) = sum(ds.savage2.FOC(:,2) == 1 & ds.savage2.FOC(:,3) == 1) / sum(ds.savage2.FOC(:,2) == 1);
       soc_perf(i) = sum(ds.savage2.SOC(:,2) == 1 & ds.savage2.SOC(:,3) == 1) / sum(ds.savage2.SOC(:,2) == 1);
    else
       foc_perf(i) = sum(ds.savage_fmri.FOC(:,2) == 1 & ds.savage_fmri.FOC(:,3) == 1) / sum(ds.savage_fmri.FOC(:,2) == 1);
       soc_perf(i) = sum(ds.savage_fmri.resultsSOC(:,2) == 1 & ds.savage_fmri.resultsSOC(:,3) == 1) / sum(ds.savage_fmri.resultsSOC(:,2) == 1);
       
    end
        

    %% CS1 choices
    %percent CS1 plus chosen
    CS1plus = length(find(forcedchoicefractals(:,2) == 2 & forcedchoicefractals(:,12) == 1 | forcedchoicefractals(:,3) == 2 & forcedchoicefractals(:,12) == 2));
    percentchoiceCS1plus = CS1plus/length(find(forcedchoicefractals(:,2) == 2 | forcedchoicefractals(:,3) == 2));
    results(i,2) = percentchoiceCS1plus;
    
    %percent CS1 minus chosen (should be the same as (1 - results(i,2)))
    CS1minus = length(find(forcedchoicefractals(:,2) == 1 & forcedchoicefractals(:,12) == 1 | forcedchoicefractals(:,3) == 1 & forcedchoicefractals(:,12) == 2));
    percentchoiceCS1minus = CS1minus/length(find(forcedchoicefractals(:,2) == 1 | forcedchoicefractals(:,3) == 1));
    results(i,3) = percentchoiceCS1minus;
    
    %RT for higher valued CS1 chosen
    highvalL = find(forcedchoicefractals(:,2) == 2 & forcedchoicefractals(:,3) == 1 & forcedchoicefractals(:,12) == 1);
    highvalR = find(forcedchoicefractals(:,2) == 1 & forcedchoicefractals(:,3) == 2 & forcedchoicefractals(:,12) == 2);
    highvalRT = [forcedchoicefractals(highvalL,13);
        forcedchoicefractals(highvalR,13)];
    
    %mean RT for higher valued CS1 chosen
    medianRThighval = nanmedian(forcedchoicefractals([highvalL; highvalR], 13));
    results(i,4) =  medianRThighval;
    
    %RT for lower valued CS1 chosen
    lowvalL = find(forcedchoicefractals(:,2) == 2 & forcedchoicefractals(:,3) == 1 & forcedchoicefractals(:,12) == 2);
    lowvalR = find(forcedchoicefractals(:,2) == 1 & forcedchoicefractals(:,3) == 2 & forcedchoicefractals(:,12) == 1);
    lowvalRT = [forcedchoicefractals(lowvalL,13);
        forcedchoicefractals(lowvalR,13)];
    
    %mean RT for lower valued CS1 chosen
    medianRTlowval = nanmedian(forcedchoicefractals([lowvalL; lowvalR], 13));
    results(i,5) =  medianRTlowval;
    
    %percent CS1 neutral chosen
    CS1neutral = length(find(forcedchoicefractals(:,2) == 3 & forcedchoicefractals(:,12) == 1 | forcedchoicefractals(:,3) == 3 & forcedchoicefractals(:,12) == 2));
    percentchoiceCS1neutral = CS1neutral/length(find(forcedchoicefractals(:,2) == 3 | forcedchoicefractals(:,3) == 3));
    results(i,6) = percentchoiceCS1neutral;
    
    %mean RT for all choices CS1
    medianRT = nanmedian(forcedchoicefractals(:,13));
    results(i,7) = medianRT;
    
    if isfield(ds,'savage2')
        results(i,8) = ds.savage2.pcorrect;
    else
        results(i,8) = savage_fmri_pre.pcorrectFOC;
    end
    
    if isfield(ds,'savage2')
        %mean RT for target responses FOC
        respo = find(ds.savage2.FOC(:,2) == 1 & ds.savage2.FOC(:,3) == 1);
        results(i,24) = nanmedian(ds.savage2.FOC(respo,4));
        
        %mean RT for target responses, US-
        respominus = find(ds.savage2.FOC(:,2) == 1 & ds.savage2.FOC(:,3) == 1 & ds.savage2.FOC(:,7) == 1);
        results(i,25) = nanmedian(ds.savage2.FOC(respominus,4));
        
        %mean RT for target responses, US+
        respoplus = find(ds.savage2.FOC(:,2) == 1 & ds.savage2.FOC(:,3) == 1 & ds.savage2.FOC(:,7) == 2);
        results(i,26) = nanmedian(ds.savage2.FOC(respoplus,4));
        
    else
    
        %mean RT for target responses FOC
        respo = find(ds.savage_fmri.FOC(:,2) == 1 & ds.savage_fmri.FOC(:,3) == 1);
        results(i,24) = nanmedian(ds.savage_fmri.FOC(respo,4));
        
        %mean RT for target responses, US-
        respominus = find(ds.savage_fmri.FOC(:,2) == 1 & ds.savage_fmri.FOC(:,3) == 1 & ds.savage_fmri.FOC(:,7) == 1);
        results(i,25) = nanmedian(ds.savage_fmri.FOC(respominus,4));
        
        %mean RT for target responses, US+
        respoplus = find(ds.savage_fmri.FOC(:,2) == 1 & ds.savage_fmri.FOC(:,3) == 1 & ds.savage_fmri.FOC(:,7) == 2);
        results(i,26) = nanmedian(ds.savage_fmri.FOC(respoplus,4));
    
    end
    %% CS1 lure stimuli
    results_lures(i,1) = name;
    
    %CS1n
    results_lures(i,2) = results(i,6);
    
    %CS1 Lure1 overall
    CS1lure1= length(find(forcedchoicefractals(:,2) == 4 & forcedchoicefractals(:,12) == 1 | forcedchoicefractals(:,3) == 4 & forcedchoicefractals(:,12) == 2));
    percentchoiceCS1lure1 = CS1lure1/length(find(forcedchoicefractals(:,2) == 4 | forcedchoicefractals(:,3) == 4));
    results_lures(i,3) = percentchoiceCS1lure1;
    
    %CS1 Lure2 overall
    CS1lure2= length(find(forcedchoicefractals(:,2) == 5 & forcedchoicefractals(:,12) == 1 | forcedchoicefractals(:,3) == 5 & forcedchoicefractals(:,12) == 2));
    percentchoiceCS1lure2 = CS1lure2/length(find(forcedchoicefractals(:,2) == 5 | forcedchoicefractals(:,3) == 5));
    results_lures(i,4) = percentchoiceCS1lure2;
    
    %CS1 Lure1 vs CS1n
    CS1lure1vsCS1neutral= length(find(forcedchoicefractals(:,2) == 4 & forcedchoicefractals(:,3) == 3 & forcedchoicefractals(:,12) == 1 | forcedchoicefractals(:,3) == 4 & forcedchoicefractals(:,2) == 3 & forcedchoicefractals(:,12) == 2));
    percentchoiceCS1lure1vsCS1neutral = CS1lure1vsCS1neutral/length(find(forcedchoicefractals(:,2) == 4 & forcedchoicefractals(:,3) == 3 | forcedchoicefractals(:,2) == 3 & forcedchoicefractals(:,3) == 4));
    results_lures(i,5) = percentchoiceCS1lure1vsCS1neutral;
    
    %CS1 Lure2 vs CS1n
    CS1lure2vsCS1neutral= length(find(forcedchoicefractals(:,2) == 5 & forcedchoicefractals(:,3) == 3 & forcedchoicefractals(:,12) == 1 | forcedchoicefractals(:,3) == 5 & forcedchoicefractals(:,2) == 3 & forcedchoicefractals(:,12) == 2));
    percentchoiceCS1lure2vsCS1neutral = CS1lure2vsCS1neutral/length(find(forcedchoicefractals(:,2) == 5 & forcedchoicefractals(:,3) == 3 | forcedchoicefractals(:,2) == 3 & forcedchoicefractals(:,3) == 5));
    results_lures(i,6) = percentchoiceCS1lure2vsCS1neutral;
    
    %CS1 Lure1 vs CS1 Lure2
    CS1Lure1vsCS1Lure2 = length(find(forcedchoicefractals(:,2) == 4 & forcedchoicefractals(:,3) == 5 & forcedchoicefractals(:,12) == 1 | forcedchoicefractals(:,3) == 4 & forcedchoicefractals(:,2) == 5 & forcedchoicefractals(:,12) == 2));
    percentchoiceCS1Lure1vsCS1Lure2 = CS1Lure1vsCS1Lure2/length(find(forcedchoicefractals(:,2) == 4 & forcedchoicefractals(:,3) == 5 | forcedchoicefractals(:,2) == 5 & forcedchoicefractals(:,3) == 4));
    results_lures(i,7) = percentchoiceCS1Lure1vsCS1Lure2;
    
    %decision for higher pre-rated fractal (4 vs 5)
    highvalfractal4vs5 = length(find(forcedchoicefractals(:,2) == 4 & forcedchoicefractals(:,3) == 5 & forcedchoicefractals(:,5) >= forcedchoicefractals(:,9) & forcedchoicefractals(:,12) == 1 | forcedchoicefractals(:,2) == 4 & forcedchoicefractals(:,3) == 5 & forcedchoicefractals(:,5) <= forcedchoicefractals(:,9) & forcedchoicefractals(:,12) == 2));
    percenthighvalfractal4vs5 = highvalfractal4vs5/length(find(forcedchoicefractals(:,2) == 4 & forcedchoicefractals(:,3) == 5 | forcedchoicefractals(:,2) == 5 & forcedchoicefractals(:,3) == 4));
    results_lures(i,14) = percenthighvalfractal4vs5;
    
    %% CS2 choices
    %percent CS2 plus chosen
    CS2plus = length(find(forcedchoicekanjis(:,2) == 2 & forcedchoicekanjis(:,12) == 1 | forcedchoicekanjis(:,3) == 2 & forcedchoicekanjis(:,12) == 2));
    percentchoiceCS2plus = CS2plus/length(find(forcedchoicekanjis(:,2) == 2 | forcedchoicekanjis(:,3) == 2));
    results_kanji(i,2) = percentchoiceCS2plus;
    
    %percent CS2 minus chosen (should be the same as (1 - results_kanji(i,2)))
    CS2minus = length(find(forcedchoicekanjis(:,2) == 1 & forcedchoicekanjis(:,12) == 1 | forcedchoicekanjis(:,3) == 1 & forcedchoicekanjis(:,12) == 2));
    percentchoiceCS2minus = CS2minus/length(find(forcedchoicekanjis(:,2) == 1 | forcedchoicekanjis(:,3) == 1));
    results_kanji(i,3) = percentchoiceCS2minus;
    
    %RT for higher valued CS2 chosen
    highvalkanjiL = find(forcedchoicekanjis(:,2) == 2 & forcedchoicekanjis(:,3) == 1 & forcedchoicekanjis(:,12) == 1);
    highvalkanjiR = find(forcedchoicekanjis(:,2) == 1 & forcedchoicekanjis(:,3) == 2 & forcedchoicekanjis(:,12) == 2);
    highvalkanjiRT = [forcedchoicekanjis(highvalkanjiL,13);
        forcedchoicekanjis(highvalkanjiR,13)];
    
    %mean RT for higher valued CS2 chosen
    medianRThighvalkanji = nanmedian(forcedchoicekanjis([highvalkanjiL; highvalkanjiR], 13));
    results_kanji(i,4) =  medianRThighvalkanji;
    
    
    %RT for lower valued CS2 chosen
    lowvalkanjiL = find(forcedchoicekanjis(:,2) == 2 & forcedchoicekanjis(:,3) == 1 & forcedchoicekanjis(:,12) == 2);
    lowvalkanjiR = find(forcedchoicekanjis(:,2) == 1 & forcedchoicekanjis(:,3) == 2  & forcedchoicekanjis(:,12) == 1);
    lowvalkanjiRT = [forcedchoicekanjis(lowvalkanjiL,13);
        forcedchoicekanjis(lowvalkanjiR,13)];
    
    %mean RT for lower valued CS2 chosen
    medianRTlowvalkanji = nanmedian(forcedchoicekanjis([lowvalkanjiL; lowvalkanjiR], 13));
    results_kanji(i,5) =  medianRTlowvalkanji;
    
    %percent CS2 neutral chosen
    CS2neutral = length(find(forcedchoicekanjis(:,2) == 3 & forcedchoicekanjis(:,12) == 1 | forcedchoicekanjis(:,3) == 3 & forcedchoicekanjis(:,12) == 2));
    percentchoiceCS2neutral = CS2neutral/length(find(forcedchoicekanjis(:,2) == 3 | forcedchoicekanjis(:,3) == 3));
    results_kanji(i,6) = percentchoiceCS2neutral;
    
    %mean RT for all choices CS2
    medianRTkanji = nanmedian(forcedchoicekanjis(:,13));
    results_kanji(i,7) = medianRTkanji;
   
    if isfield(ds,'savage2')
        
        %percent correct answers during SOC
        correct = sum(ds.savage2.SOC(:,2) == 1 & ds.savage2.SOC(:,3) == 1);
        pcorrect_SOC = (sum(correct)/(sum(ds.savage2.SOC(:,2))))*100;
        results_kanji(i,8) = pcorrect_SOC;
        
        %mean RT for target responses
        respoSOC = find(ds.savage2.SOC(:,2) == 1 & ds.savage2.SOC(:,3) == 1);
        results_kanji(i,18) = nanmedian(ds.savage2.SOC(respoSOC,4));
        
        %mean RT for target responses, US-
        respoSOCminus= find(ds.savage2.SOC(:,2) == 1 & ds.savage2.SOC(:,3) == 1 & ds.savage2.SOC(:,8) == 1);
        results_kanji(i,19) = nanmedian(ds.savage2.SOC(respoSOCminus,4));
        
        %mean RT for target responses, US+
        respoSOCplus = find(ds.savage2.SOC(:,2) == 1 & ds.savage2.SOC(:,3) == 1 & ds.savage2.SOC(:,8) == 2);
        results_kanji(i,20) = nanmedian(ds.savage2.SOC(respoSOCplus,4));
        
        %mean RT for target responses, CS2-CS1 neut
        respoSOCneut = find(ds.savage2.SOC(:,2) == 1 & ds.savage2.SOC(:,3) == 1 & ds.savage2.SOC(:,8) == ds.savage2.SOC(:,9));
        results_kanji(i,21) = nanmedian(ds.savage2.SOC(respoSOCneut,4));
    else
        
        %percent correct answers during SOC
        correct = sum(ds.savage_fmri.resultsSOC(:,2) == 1 & ds.savage_fmri.resultsSOC(:,3) == 1);
        pcorrect_SOC = (sum(correct)/(sum(ds.savage_fmri.resultsSOC(:,2))))*100;
        results_kanji(i,8) = pcorrect_SOC;
        
        %mean RT for target responses
        respoSOC = find(ds.savage_fmri.resultsSOC(:,2) == 1 & ds.savage_fmri.resultsSOC(:,3) == 1);
        results_kanji(i,18) = nanmedian(ds.savage_fmri.resultsSOC(respoSOC,4));
        
        %mean RT for target responses, US-
        respoSOCminus= find(ds.savage_fmri.resultsSOC(:,2) == 1 & ds.savage_fmri.resultsSOC(:,3) == 1 & ds.savage_fmri.resultsSOC(:,8) == 1);
        results_kanji(i,19) = nanmedian(ds.savage_fmri.resultsSOC(respoSOCminus,4));
        
        %mean RT for target responses, US+
        respoSOCplus = find(ds.savage_fmri.resultsSOC(:,2) == 1 & ds.savage_fmri.resultsSOC(:,3) == 1 & ds.savage_fmri.resultsSOC(:,8) == 2);
        results_kanji(i,20) = nanmedian(ds.savage_fmri.resultsSOC(respoSOCplus,4));
        
        %mean RT for target responses, Sd-Si neut
        respoSOCneut = find(ds.savage_fmri.resultsSOC(:,2) == 1 & ds.savage_fmri.resultsSOC(:,3) == 1 & ds.savage_fmri.resultsSOC(:,8) == ds.savage_fmri.resultsSOC(:,9));
        results_kanji(i,21) = nanmedian(ds.savage_fmri.resultsSOC(respoSOCneut,4));
        
    end
    
    %% CS2 lures
    
    %CS2n
    results_lures(i,8) = results_kanji(i,6);
    
    %CS2 lure1
    CS2lure1= length(find(forcedchoicekanjis(:,2) == 4 & forcedchoicekanjis(:,12) == 1 | forcedchoicekanjis(:,3) == 4 & forcedchoicekanjis(:,12) == 2));
    percentchoiceCS2lure1 = CS2lure1/length(find(forcedchoicekanjis(:,2) == 4 | forcedchoicekanjis(:,3) == 4));
    results_lures(i,9) = percentchoiceCS2lure1;
    
    %CS2 lure2
    CS2lure2= length(find(forcedchoicekanjis(:,2) == 5 & forcedchoicekanjis(:,12) == 1 | forcedchoicekanjis(:,3) == 5 & forcedchoicekanjis(:,12) == 2));
    percentchoiceCS2lure2 = CS2lure2/length(find(forcedchoicekanjis(:,2) == 5 | forcedchoicekanjis(:,3) == 5));
    results_lures(i,10) = percentchoiceCS2lure2;
    
    %CS2 Lure1 vs CS2n
    CS2lure1vsCS2neutral= length(find(forcedchoicekanjis(:,2) == 4 & forcedchoicekanjis(:,3) == 3 & forcedchoicekanjis(:,12) == 1 | forcedchoicekanjis(:,3) == 4 & forcedchoicekanjis(:,2) == 3 & forcedchoicekanjis(:,12) == 2));
    percentchoiceCS2lure1vsCS2neutral = CS2lure1vsCS2neutral/length(find(forcedchoicekanjis(:,2) == 4 & forcedchoicekanjis(:,3) == 3 | forcedchoicekanjis(:,2) == 3 & forcedchoicekanjis(:,3) == 4));
    results_lures(i,11) = percentchoiceCS2lure1vsCS2neutral;
    
    %CS2 Lure2 vs CS2 n
    CS2lure2vsCS2neutral= length(find(forcedchoicekanjis(:,2) == 5 & forcedchoicekanjis(:,3) == 3 & forcedchoicekanjis(:,12) == 1 | forcedchoicekanjis(:,3) == 5 & forcedchoicekanjis(:,2) == 3 & forcedchoicekanjis(:,12) == 2));
    percentchoiceCS2lure2vsCS2neutral = CS2lure2vsCS2neutral/length(find(forcedchoicekanjis(:,2) == 5 & forcedchoicekanjis(:,3) == 3 | forcedchoicekanjis(:,2) == 3 & forcedchoicekanjis(:,3) == 5));
    results_lures(i,12) = percentchoiceCS2lure2vsCS2neutral;
    
    %CS2 Lure1 vs CS2 Lure2
    CS2lure1vsCS2lure2= length(find(forcedchoicekanjis(:,2) == 4 & forcedchoicekanjis(:,3) == 5 & forcedchoicekanjis(:,12) == 1 | forcedchoicekanjis(:,3) == 4 & forcedchoicekanjis(:,2) == 5 & forcedchoicekanjis(:,12) == 2));
    percentchoiceCS2lure1vsCS2lure2 = CS2lure1vsCS2lure2/length(find(forcedchoicekanjis(:,2) == 4 & forcedchoicekanjis(:,3) == 5 | forcedchoicekanjis(:,2) == 5 & forcedchoicekanjis(:,3) == 4));
    results_lures(i,13) = percentchoiceCS2lure1vsCS2lure2;
    
    %decision for higher pre-rated kanji (4 vs 5)
    highvalkanji4vs5 = length(find(forcedchoicekanjis(:,2) == 4 & forcedchoicekanjis(:,3) == 5 & forcedchoicekanjis(:,5) >= forcedchoicekanjis(:,9) & forcedchoicekanjis(:,12) == 1 | forcedchoicekanjis(:,2) == 4 & forcedchoicekanjis(:,3) == 5 & forcedchoicekanjis(:,5) <= forcedchoicekanjis(:,9) & forcedchoicekanjis(:,12) == 2));
    percenthighvalkanji4vs5 = highvalkanji4vs5/length(find(forcedchoicekanjis(:,2) == 4 & forcedchoicekanjis(:,3) == 5 | forcedchoicekanjis(:,2) == 5 & forcedchoicekanjis(:,3) == 4));
    results_lures(i,15) = percenthighvalkanji4vs5;
    
    %% Ratings - second-order conditioning (day 2 in fMRI sample)
    
    if isfield(ds,'savage2')
        %US ratings pre
        [~, pos_min] = find(ds.savage2.ratingfoodcues(4,:)==1);
        [~, pos_max] = find(ds.savage2.ratingfoodcues(4,:)==2);
        
        %valence
        results(i,9) = ds.savage2.ratingfoodcues(2,pos_min);%US-
        results(i,12) = ds.savage2.ratingfoodcues(2,pos_max);%US+
        
        %intensity - not performed
        results(i,15) = NaN;
        results(i,18) = NaN;
        
        %US ratings post
        pos_max = [];
        pos_min = [];
        
        [~, pos_min] = find(ds.savage2.postratingfoodcues(4,:)==1);
        [~, pos_max] = find(ds.savage2.postratingfoodcues(4,:)==2);
        
        %valence
        results(i,10) = ds.savage2.postratingfoodcues(2,pos_min);%US-
        results(i,13) = ds.savage2.postratingfoodcues(2,pos_max);%US+
        
        %intensity - not performed
        results(i,16) = NaN;
        results(i,19) = NaN;
        
    else
        %US ratings pre
        [~, pos_min] = find(savage_fmri_pre.ratingfoodcues(6,:)==1);
        [~, pos_max] = find(savage_fmri_pre.ratingfoodcues(6,:)==2);
        
        %valence
        results(i,9) = savage_fmri_pre.ratingfoodcues(2,pos_min);%US-
        results(i,12) = savage_fmri_pre.ratingfoodcues(2,pos_max);%US+
        
        %intensity
        results(i,15) = savage_fmri_pre.ratingfoodcues(4,pos_min);%US-
        results(i,18) = savage_fmri_pre.ratingfoodcues(4,pos_max);%US+
        
        %US ratings post
        pos_max = [];
        pos_min = [];
        
        [~, pos_min] = find(savage_fmri_post.postratingfoodcues(6,:)==1);
        [~, pos_max] = find(savage_fmri_post.postratingfoodcues(6,:)==2);
        
        %valence
        results(i,10) = savage_fmri_post.postratingfoodcues(2,pos_min);%US-
        results(i,13) = savage_fmri_post.postratingfoodcues(2,pos_max);%US+
        
        %intensity
        results(i,16) = savage_fmri_post.postratingfoodcues(4,pos_min);%US-
        results(i,19) = savage_fmri_post.postratingfoodcues(4,pos_max);%US+
    
    end

    %pre-post valence
    results(i,11) = results(i,10) - results(i,9);
    results(i,14) = results(i,13) - results(i,12);
    
    %pre-post intensity
    results(i,17) = results(i,16) - results(i,15);
    results(i,20) = results(i,19) - results(i,18);
    
    if isfield(ds,'savage2')
        %Difference score pre- to post-exp rating of CS
        for j = 1:3
            prepostfractal = find(ds.savage2.ratingfractals(4,j) == ds.savage2.postratingfractals(4,:));
            
            value = find(ds.savage2.ratingfractals(4,j) == ds.savage2.SOC(:,7));
            valuefractal = ds.savage2.SOC(value(1),9) ;
            
            difffractal(1,j) = ds.savage2.ratingfractals(2,j);
            difffractal(2,j) = ds.savage2.postratingfractals(2,prepostfractal);
            difffractal(3,j) = ds.savage2.postratingfractals(2,prepostfractal) - ds.savage2.ratingfractals(2,j);
            difffractal(4,j) = valuefractal;
            difffractal(5,j) = ds.savage2.ratingfractals(4,j);
        end
     
    else
        %Difference score pre- to post-exp rating of CS1
        new_fracs = [ds.savage_fmri.fractals ds.savage_fmri.fractalslures(1)];
        for j = 1:3
            prepostfractal = find(savage_fmri_pre.ratingfractals(4,j) == savage_fmri_post.postratingfractals(4,:));
            
            value = find(ds.savage_fmri.resultsSOC(:,27) == j);
            valuefractal = ds.savage_fmri.resultsSOC(value(1),9) ;
            
            difffractal(1,j) = ds.savage_fmri.ratingfractals(2,j);
            difffractal(2,j) = savage_fmri_post.postratingfractals(2,prepostfractal);
            difffractal(3,j) = savage_fmri_post.postratingfractals(2,prepostfractal) - ds.savage_fmri.ratingfractals(2,j);
            difffractal(4,j) = valuefractal;
            difffractal(5,j) = new_fracs(j);
        end
    
    end
    %CS1-
    results(i,21) = difffractal(1,1);
    results(i,22) = difffractal(2,1);
    results(i,23) = difffractal(3,1);
    %CS1+
    results(i,24) = difffractal(1,2);
    results(i,25) = difffractal(2,2);
    results(i,26) = difffractal(3,2);
    %CS1n
    results(i,27) = difffractal(1,3);
    results(i,28) = difffractal(2,3);
    results(i,29) = difffractal(3,3);
    
    j = [];
    value = [];
    
    %Difference score pre- to post-exp rating of CS2
    if isfield(ds,'savage2')
        for j = 1:3
            prepostkanjis = find(ds.savage2.ratingkanjis(4,j) == ds.savage2.postratingkanjis(4,:));
            value = find(ds.savage2.ratingkanjis(4,j) == ds.savage2.SOC(:,5));
            valuekanjis= ds.savage2.SOC(value(1),9) ;
            
            diffkanjis(1,j) = ds.savage2.ratingkanjis(2,j);
            diffkanjis(2,j) = ds.savage2.postratingkanjis(2,prepostkanjis);
            diffkanjis(3,j) = ds.savage2.postratingkanjis(2,prepostkanjis) - ds.savage2.ratingkanjis(2,j);
            diffkanjis(4,j) = valuekanjis;
            diffkanjis(5,j) = ds.savage2.ratingkanjis(4,j);
        end
    else    
        new_kanjis = [ds.savage_fmri.kanjis ds.savage_fmri.kanjislures(1)];
    
        for j = 1:3
            prepostkanjis = find(ds.savage_fmri.ratingkanjis(4,j) == savage_fmri_post.postratingkanjis(4,:));

            value = find(ds.savage_fmri.resultsSOC(:,27) == j);
            valuekanjis= ds.savage_fmri.resultsSOC(value(1),9) ;

            diffkanjis(1,j) = ds.savage_fmri.ratingkanjis(2,j);
            diffkanjis(2,j) = savage_fmri_post.postratingkanjis(2,prepostkanjis);
            diffkanjis(3,j) = savage_fmri_post.postratingkanjis(2,prepostkanjis) - ds.savage_fmri.ratingkanjis(2,j);
            diffkanjis(4,j) = valuekanjis;
            diffkanjis(5,j) = new_kanjis(j);
        end
    
    end
    
    %CS2-
    results_kanji(i,9) = diffkanjis(1,1);
    results_kanji(i,10) = diffkanjis(2,1);
    results_kanji(i,11) = diffkanjis(3,1);
    
    %CS2+
    results_kanji(i,12) = diffkanjis(1,2);
    results_kanji(i,13) = diffkanjis(2,2);
    results_kanji(i,14) = diffkanjis(3,2);
    
    %CS2n
    results_kanji(i,15) = diffkanjis(1,3);
    results_kanji(i,16) = diffkanjis(2,3);
    results_kanji(i,17) = diffkanjis(3,3);
    
    
    if sum(results(i,1) == exclude) > 0
        results(i,2:end) = NaN;
        results_kanji(i,2:end) = NaN;
        payout_corr(i,:) = NaN;
        foc_perf(i) = NaN;
        soc_perf(i) = NaN;
        if sample == 2
           results_classifier(i,2:end) = NaN;
        end

    end

    %write in long format
    if sum(results(i,1) == exclude) == 0 && sample == 3
        
        
       choices(1,:) = CS2plus; %choices of CS1+
       choices(2,:) = CS1plus; %choices of CS2+
       choices(3,:) = CS1neutral; %choices of CS1n
       choices(4,:) = CS2neutral; %choices of CS2n
       
       total_choices(1,:) = length(find(forcedchoicefractals(:,2) == 2 | forcedchoicefractals(:,3) == 2)); %total choices involving CS1+
       total_choices(2,:) = length(find(forcedchoicekanjis(:,2) == 2 | forcedchoicekanjis(:,3) == 2)); %total choices involving CS2+
       total_choices(3,:) = length(find(forcedchoicefractals(:,2) == 3 | forcedchoicefractals(:,3) == 3)); %total choices involving CS1n
       total_choices(4,:) = length(find(forcedchoicekanjis(:,2) == 3 | forcedchoicekanjis(:,3) == 3)); %total choices involving CS2n

       condition = [1;2;3;4];
            
       long_CS = [long_CS; repmat(name,4,1) condition choices total_choices repmat(ofc_cluster(k),4,1) repmat(index(k),4,1)];
       
       k = k+1;
    end
    
   
end

%save long format
% long_CS(1:80,5:6) = NaN;
% 
% cd /.../MLM
% varNames = {'SubID','CS', 'choices', 'total_choices', 'ofc_acc', 'bias'};
% CS_l = array2table(long_CS,'VariableNames',varNames);
%     
%     
% writetable(CS_l,'savage_long.csv','Delimiter',',');



if sum(exclude) > 0
   results = results(~isnan(results(:,2)),:);
   results_kanji = results_kanji(~isnan(results_kanji(:,2)),:);
   foc_perf = foc_perf(~isnan(foc_perf));
   soc_perf = soc_perf(~isnan(soc_perf));

   if sample == 2
      results_classifier = results_classifier(~isnan(results_classifier(:,2)),:);
   end
end

%% statistical tests

%test explicit knowledge vs. chance (0.5)
%CS1
pout1 = myBinomTest(sum(knowledge(:,1)),numel(knowledge(:,1)),0.5,'two')

%CS2
pout2 = myBinomTest(sum(knowledge(:,2)),numel(knowledge(:,2)),0.5,'two')


%compare US temperatures
if sample == 2
       
   mean(temperature)
   std(temperature)
   
   %localizer
   [h,p,ci,stats] = ttest(temperature(:,1),temperature(:,2))

   %FOC+SOC
   [h,p,ci,stats] = ttest(temperature(:,3),temperature(:,4))
   
end

% mean percent correct attentional control task
%FOC

mean(foc_perf)
std(foc_perf)

mean(soc_perf)
std(soc_perf)


%compare median RTs for high vs. low valued option
foc_rts = [results(:,4) results(:,5) (results(:,5) - results(:,4))]; %Sdminus, Sdplus, difference
soc_rts = [results_kanji(:,4) results_kanji(:,5) (results_kanji(:,5) - results_kanji(:,4))]; %Siminus, Siplus, difference

nanmean(foc_rts)
nanmean(soc_rts)

%FOC
[h,p,ci,stats] = ttest(foc_rts(:,1),foc_rts(:,2))
[P,H,STATS] = signrank(foc_rts(:,1),foc_rts(:,2))

%SOC
[h,p,ci,stats] = ttest(soc_rts(:,1),soc_rts(:,2))
[P,H,STATS] = signrank(soc_rts(:,1),soc_rts(:,2))


CS1plus_vs_CS1minus = results(:,2);

CS2plus_vs_CS2minus = results_kanji(:,2);


CS1n = results(:,6);
CS2n = results_kanji(:,6);

res_to_plot = [CS1plus_vs_CS1minus CS2plus_vs_CS2minus CS1n CS2n];

lures_to_plot = results_lures(:,2:13); %Sdn, Sdlure1, Sdlure2, Sdlure1 vs Sdn, Sdlure2 vs Sdn, Sdlure1 vs Sdlure2, 
                                        %Sin, SiLure1,  SiLure2, Silure1 vs Sin, Silure2 vs Sin, SiLure1 vs SiLure2

 

%save wide format 
% CS_w = [results(:,1) res_to_plot];
% 
% varNames = {'SubID','CS1plus', 'CS2plus', 'CS1n', 'CS2n'};
% CS_wide = array2table(CS_w,'VariableNames',varNames);
%     
%     
% writetable(CS_wide,'savage_wide.csv','Delimiter',',');


%% CS ratings - learning experiment

%pre-rating difference of selected CS1
pre_fractals = results(:,21:3:29);
nanmean(pre_fractals)
nanstd(pre_fractals)

% repeated measures ANOVA on CS subjective value (pre-rating) 
data = pre_fractals;
varNames = {'S1','S2','S3'};

t = array2table(data,'VariableNames',varNames);

factorNames = {'stimulus'};
within = table({'one'; 'two';'three'},'VariableNames',factorNames);


rm = fitrm(t,'S1-S3~1','WithinDesign',within); 


[ranovatbl] = ranova(rm, 'WithinModel', 'stimulus');

disp('rmANOVA on fractal ratings')
ranovatbl


[h,p,ci,stats] = ttest(pre_fractals(:,1),pre_fractals(:,2))
[h,p,ci,stats] = ttest(pre_fractals(:,1),pre_fractals(:,3))
[h,p,ci,stats] = ttest(pre_fractals(:,2),pre_fractals(:,3))



%calculate partial eta square
disp('rmANOVA effect size of ME stimulus pre')
cp_data=data(:,1);
data_rm = [data(:,1) data(:,2) data(:,3)];

mes1way(data_rm,'partialeta2','isDep',1)


%pre-rating difference of selected CS2
pre_kanji = results_kanji(:,9:3:17);
nanmean(pre_kanji)
nanstd(pre_kanji)

% repeated measures ANOVA on CS subjective value (pre-rating) 
data = pre_kanji;
varNames = {'S1','S2','S3'};

t = array2table(data,'VariableNames',varNames);

factorNames = {'stimulus'};
within = table({'one'; 'two';'three'},'VariableNames',factorNames);


rm = fitrm(t,'S1-S3~1','WithinDesign',within); 


[ranovatbl] = ranova(rm, 'WithinModel', 'stimulus');

disp('rmANOVA on kanjis ratings')
ranovatbl

%calculate partial eta square 
disp('overall choice probability rmANOVA effect size of ME stimulus pre')
cp_data=data(:,1);
data_rm = [data(:,1) data(:,2) data(:,3)];

mes1way(data_rm,'partialeta2','isDep',1)


%% US ratings (valence) - learning experiment

%valence
us_ratings = [results(:,9:10) results(:,12:13)];
nanmean(us_ratings)
nanstd(us_ratings)

% repeated measures ANOVA on CS subjective value (pre-rating) 
data = us_ratings;
varNames = {'US1_pre','US2_pre','US1_post','US2_post'};

t = array2table(data,'VariableNames',varNames);

factorNames = {'stimulus', 'time'};
within = table({'one'; 'one';'two';'two'},{'pre'; 'post';'pre';'post'},'VariableNames',factorNames);


rm = fitrm(t,'US1_pre-US2_post~1','WithinDesign',within); 


[ranovatbl] = ranova(rm, 'WithinModel', 'stimulus*time');

disp('rmANOVA on US ratings')
ranovatbl


%calculate partial eta square 
cp_data=data(:,1);
time = [repmat(1,length(cp_data),1);repmat(2,length(cp_data),1);repmat(1,length(cp_data),1);repmat(2,length(cp_data),1)];
stimulus = [repmat(1,length(cp_data),1);repmat(1,length(cp_data),1);repmat(2,length(cp_data),1);repmat(2,length(cp_data),1)];
data_rm = [data(:,1); data(:,2); data(:,3); data(:,4)];

mes2way(data_rm,[time stimulus],'partialeta2','isDep',[1 1])



    
    
%% US ratings (intensity, only in fMRI sample) - learning experiment
if sample ~= 1
    %intensity
    us_ratings_int = [results(:,15:16) results(:,18:19)];
    nanmean(us_ratings_int)
    nanstd(us_ratings_int)

    % repeated measures ANOVA on CS subjective value (pre-rating) 
    data = us_ratings_int;
    varNames = {'US1_pre','US2_pre','US1_post','US2_post'};

    t = array2table(data,'VariableNames',varNames);

    factorNames = {'stimulus', 'time'};
    within = table({'one'; 'one';'two';'two'},{'pre'; 'post';'pre';'post'},'VariableNames',factorNames);


    rm = fitrm(t,'US1_pre-US2_post~1','WithinDesign',within); 


    [ranovatbl] = ranova(rm, 'WithinModel', 'stimulus*time');

    disp('rmANOVA on US ratings')
    ranovatbl


    %calculate partial eta square 
    cp_data=data(:,1);
    time = [repmat(1,length(cp_data),1);repmat(2,length(cp_data),1);repmat(1,length(cp_data),1);repmat(2,length(cp_data),1)];
    stimulus = [repmat(1,length(cp_data),1);repmat(1,length(cp_data),1);repmat(2,length(cp_data),1);repmat(2,length(cp_data),1)];
    data_rm = [data(:,1); data(:,2); data(:,3); data(:,4)];

    mes2way(data_rm,[time stimulus],'partialeta2','isDep',[1 1])
end


%% plot rating (Supplementary Fig. 2)
cols = [];

cols.k = [0 0 0];
cols.b = [0 .058 .686];
cols.y = [1  .828 0];
cols.grey = [0.7843 0.7843 0.7843];
cols.dgrey = [0.1922 0.2000 0.2078];

positions = [1 2 3 4];   
pos = [positions-.2; ...
       positions+.2];
size_vec = [1 2 3 4];



figure;  
%CS2 ratings
subplot(221)
bar(1:3,mean(pre_kanji), 'w', 'BarWidth', 0.6, 'linewidth', 2.5); hold all;
scatter(linspace(pos(1,1), pos(2,1),length(pre_kanji(:,1))), pre_kanji(:,1), 250, 'o', 'MarkerFaceColor',  cols.grey, 'MarkerEdgeColor', cols.dgrey,'LineWidth',0.5); 
scatter(linspace(pos(1,2), pos(2,2), length(pre_kanji(:,2))), pre_kanji(:,2), 250, 'o', 'MarkerFaceColor',  cols.grey, 'MarkerEdgeColor', cols.dgrey,'LineWidth',0.5);
scatter(linspace(pos(1,3), pos(2,3), length(pre_kanji(:,3))), pre_kanji(:,3), 250, 'o', 'MarkerFaceColor',  cols.grey, 'MarkerEdgeColor', cols.dgrey,'LineWidth',0.5);
errorbar(positions(1),mean(pre_kanji(:,1)), std(pre_kanji(:,1))./sqrt(size(pre_kanji(:,1),1)), 'linestyle', 'none', 'color', 'k', 'CapSize', 0, 'LineWidth', 4);
errorbar(positions(2),mean(pre_kanji(:,2)), std(pre_kanji(:,2))./sqrt(size(pre_kanji(:,2),1)), 'linestyle', 'none', 'color', 'k', 'CapSize', 0, 'LineWidth', 4);
errorbar(positions(3),mean(pre_kanji(:,3)), std(pre_kanji(:,3))./sqrt(size(pre_kanji(:,3),1)), 'linestyle', 'none', 'color', 'k', 'CapSize', 0, 'LineWidth', 4);
LabelsCS ={'CS_{2}^{-}', 'CS_{2}^{+}', 'CS_{2}^{n}'};
ylim([0.75 9.25]);     
xlim([0 4]);
box off
title('CS_{2} Valence');
ylabel('Rating')
set(findobj(gca,'type','line'),'linew',5)
set(gca,'TickLength',[0.01, 0.001],'linewidth',2.5)
ybounds = ylim;
yline(0, 'linewidth', 2.5)
set(gca,'YTick',[1 5 9], 'FontSize',30,'FontName', 'Arial');
set(gca,'TickDir','out')
set(gca,'xtick',1:3)
set(gca,'XTickLabel', LabelsCS, 'FontSize',30,'FontName', 'Arial');
% set(gca,'XTickLabelRotation', 45);
set(gcf,'color','w');
set(gca,'ycolor',cols.k)
set(gca,'xcolor',cols.k)
ticklabels_new = cell(size(LabelsCS));
for i = 1:length(LabelsCS)
    ticklabels_new{i} = ['\color{black} ' LabelsCS{i}];
end
% set the tick labels
set(gca, 'XTickLabel', ticklabels_new,'FontSize',30,'FontName', 'Arial');
% prepend a color for each tick label
LabelsY = get(gca,'YTickLabel');
ticklabels_ynew = cell(size(LabelsY));
for i = 1:length(LabelsY)
    ticklabels_ynew{i} = ['\color{black} ' LabelsY{i}];
end
% set the tick labels
set(gca, 'YTickLabel', ticklabels_ynew,'FontSize',30,'FontName', 'Arial');  

%CS1 ratings
subplot(222)
bar(1:3,mean(pre_fractals), 'w', 'BarWidth', 0.6, 'linewidth', 2.5); hold all;
scatter(linspace(pos(1,1), pos(2,1),length(pre_fractals(:,1))), pre_fractals(:,1), 250, 'o', 'MarkerFaceColor',  cols.grey, 'MarkerEdgeColor', cols.dgrey,'LineWidth',0.5); 
scatter(linspace(pos(1,2), pos(2,2), length(pre_fractals(:,2))), pre_fractals(:,2), 250, 'o', 'MarkerFaceColor',  cols.grey, 'MarkerEdgeColor', cols.dgrey,'LineWidth',0.5);
scatter(linspace(pos(1,3), pos(2,3), length(pre_fractals(:,3))), pre_fractals(:,3), 250, 'o', 'MarkerFaceColor',  cols.grey, 'MarkerEdgeColor', cols.dgrey,'LineWidth',0.5);
errorbar(positions(1),mean(pre_fractals(:,1)), std(pre_fractals(:,1))./sqrt(size(pre_fractals(:,1),1)), 'linestyle', 'none', 'color', 'k', 'CapSize', 0, 'LineWidth', 4);
errorbar(positions(2),mean(pre_fractals(:,2)), std(pre_fractals(:,2))./sqrt(size(pre_fractals(:,2),1)), 'linestyle', 'none', 'color', 'k', 'CapSize', 0, 'LineWidth', 4);
errorbar(positions(3),mean(pre_fractals(:,3)), std(pre_fractals(:,3))./sqrt(size(pre_fractals(:,3),1)), 'linestyle', 'none', 'color', 'k', 'CapSize', 0, 'LineWidth', 4);
LabelsCS ={'CS_{1}^{-}', 'CS_{1}^{+}', 'CS_{1}^{n}'};
ylim([0.75 9.25]);     
xlim([0 4]);
box off
title('CS_{1} Valence');
ylabel('Rating')
set(findobj(gca,'type','line'),'linew',5)
set(gca,'TickLength',[0.01, 0.001],'linewidth',2.5)
ybounds = ylim;
yline(0, 'linewidth', 2.5)
set(gca,'YTick',[1 5 9], 'FontSize',30,'FontName', 'Arial');
set(gca,'TickDir','out')
set(gca,'xtick',1:3)
set(gca,'XTickLabel', LabelsCS, 'FontSize',30,'FontName', 'Arial');
% set(gca,'XTickLabelRotation', 45);
set(gcf,'color','w');
set(gca,'ycolor',cols.k)
set(gca,'xcolor',cols.k)
ticklabels_new = cell(size(LabelsCS));
for i = 1:length(LabelsCS)
    ticklabels_new{i} = ['\color{black} ' LabelsCS{i}];
end
% set the tick labels
set(gca, 'XTickLabel', ticklabels_new,'FontSize',30,'FontName', 'Arial');
% prepend a color for each tick label
LabelsY = get(gca,'YTickLabel');
ticklabels_ynew = cell(size(LabelsY));
for i = 1:length(LabelsY)
    ticklabels_ynew{i} = ['\color{black} ' LabelsY{i}];
end
% set the tick labels
set(gca, 'YTickLabel', ticklabels_ynew,'FontSize',30,'FontName', 'Arial');  


subplot(223)
bar(1:4,mean(us_ratings), 'w', 'BarWidth', 0.6, 'linewidth', 2.5); hold all;
scatter(linspace(pos(1,1), pos(2,1),length(us_ratings(:,1))), us_ratings(:,1), 250, 'o', 'MarkerFaceColor',  cols.grey, 'MarkerEdgeColor', cols.dgrey,'LineWidth',0.5); 
scatter(linspace(pos(1,2), pos(2,2), length(us_ratings(:,2))), us_ratings(:,2), 250, 'o', 'MarkerFaceColor',  cols.grey, 'MarkerEdgeColor', cols.dgrey,'LineWidth',0.5);
scatter(linspace(pos(1,3), pos(2,3), length(us_ratings(:,3))), us_ratings(:,3), 250, 'o', 'MarkerFaceColor',  cols.grey, 'MarkerEdgeColor', cols.dgrey,'LineWidth',0.5);
scatter(linspace(pos(1,4), pos(2,4), length(us_ratings(:,4))), us_ratings(:,4), 250, 'o', 'MarkerFaceColor', cols.grey, 'MarkerEdgeColor', cols.dgrey,'LineWidth',0.5);
errorbar(positions(1),mean(us_ratings(:,1)), std(us_ratings(:,1))./sqrt(size(us_ratings(:,1),1)), 'linestyle', 'none', 'color', 'k', 'CapSize', 0, 'LineWidth', 4);
errorbar(positions(2),mean(us_ratings(:,2)), std(us_ratings(:,2))./sqrt(size(us_ratings(:,2),1)), 'linestyle', 'none', 'color', 'k', 'CapSize', 0, 'LineWidth', 4);
errorbar(positions(3),mean(us_ratings(:,3)), std(us_ratings(:,3))./sqrt(size(us_ratings(:,3),1)), 'linestyle', 'none', 'color', 'k', 'CapSize', 0, 'LineWidth', 4);
errorbar(positions(4),mean(us_ratings(:,4)), std(us_ratings(:,4))./sqrt(size(us_ratings(:,4),1)), 'linestyle', 'none', 'color', 'k', 'CapSize', 0, 'LineWidth', 4);
LabelsUS ={'US^{-} Pre', 'US^{-} Post','US^{+} Pre', 'US^{+} Post'};
ylim([0.75 9.25]);     
xlim([0 5]);
box off
title('US Valence');
ylabel('Rating')
set(findobj(gca,'type','line'),'linew',5)
set(gca,'TickLength',[0.01, 0.001],'linewidth',2.5)
ybounds = ylim;
yline(0, 'linewidth', 2.5)
set(gca,'YTick',[1 5 9], 'FontSize',30,'FontName', 'Arial');
set(gca,'TickDir','out')
set(gca,'xtick',size_vec)
set(gca,'XTickLabel', LabelsUS, 'FontSize',30,'FontName', 'Arial');
set(gca,'XTickLabelRotation', 45);
set(gcf,'color','w');
set(gca,'ycolor',cols.k)
set(gca,'xcolor',cols.k)
ticklabels_new = cell(size(LabelsUS));
for i = 1:length(LabelsUS)
    ticklabels_new{i} = ['\color{black} ' LabelsUS{i}];
end
% set the tick labels
set(gca, 'XTickLabel', ticklabels_new,'FontSize',30,'FontName', 'Arial');
% prepend a color for each tick label
LabelsY = get(gca,'YTickLabel');
ticklabels_ynew = cell(size(LabelsY));
for i = 1:length(LabelsY)
    ticklabels_ynew{i} = ['\color{black} ' LabelsY{i}];
end
% set the tick labels
set(gca, 'YTickLabel', ticklabels_ynew,'FontSize',30,'FontName', 'Arial');  

if sample ~= 1
    subplot(224)
    bar(1:4,nanmean(us_ratings_int), 'w', 'BarWidth', 0.6, 'linewidth', 2.5); hold all;
    scatter(linspace(pos(1,1), pos(2,1),length(us_ratings_int(21:end,1))), us_ratings_int(21:end,1), 250, 'o', 'MarkerFaceColor',  cols.grey, 'MarkerEdgeColor', cols.dgrey,'LineWidth',0.5); 
    scatter(linspace(pos(1,2), pos(2,2), length(us_ratings_int(21:end,2))), us_ratings_int(21:end,2), 250, 'o', 'MarkerFaceColor',  cols.grey, 'MarkerEdgeColor', cols.dgrey,'LineWidth',0.5);
    scatter(linspace(pos(1,3), pos(2,3), length(us_ratings_int(21:end,3))), us_ratings_int(21:end,3), 250, 'o', 'MarkerFaceColor',  cols.grey, 'MarkerEdgeColor', cols.dgrey,'LineWidth',0.5);
    scatter(linspace(pos(1,4), pos(2,4), length(us_ratings_int(21:end,4))), us_ratings_int(21:end,4), 250, 'o', 'MarkerFaceColor', cols.grey, 'MarkerEdgeColor', cols.dgrey,'LineWidth',0.5);
    errorbar(positions(1),nanmean(us_ratings_int(:,1)), nanstd(us_ratings_int(:,1))./sqrt(size(us_ratings_int(21:end,1),1)), 'linestyle', 'none', 'color', 'k', 'CapSize', 0, 'LineWidth', 4);
    errorbar(positions(2),nanmean(us_ratings_int(:,2)), nanstd(us_ratings_int(:,2))./sqrt(size(us_ratings_int(21:end,2),1)), 'linestyle', 'none', 'color', 'k', 'CapSize', 0, 'LineWidth', 4);
    errorbar(positions(3),nanmean(us_ratings_int(:,3)), nanstd(us_ratings_int(:,3))./sqrt(size(us_ratings_int(21:end,3),1)), 'linestyle', 'none', 'color', 'k', 'CapSize', 0, 'LineWidth', 4);
    errorbar(positions(4),nanmean(us_ratings_int(:,4)), nanstd(us_ratings_int(:,4))./sqrt(size(us_ratings_int(21:end,4),1)), 'linestyle', 'none', 'color', 'k', 'CapSize', 0, 'LineWidth', 4);
    LabelsUS ={'US^{-} Pre', 'US^{-} Post','US^{+} Pre', 'US^{+} Post'};
    ylim([0.75 9.25]);     
    xlim([0 5]);
    box off
    title('US Intensity (fMRI study)');
    ylabel('Rating')
    set(findobj(gca,'type','line'),'linew',5)
    set(gca,'TickLength',[0.01, 0.001],'linewidth',2.5)
    ybounds = ylim;
    yline(0, 'linewidth', 2.5)
    set(gca,'YTick',[1 5 9], 'FontSize',30,'FontName', 'Arial');
    set(gca,'TickDir','out')
    set(gca,'xtick',size_vec)
    set(gca,'XTickLabel', LabelsUS, 'FontSize',30,'FontName', 'Arial');
    set(gca,'XTickLabelRotation', 45);
    set(gcf,'color','w');
    set(gca,'ycolor',cols.k)
    set(gca,'xcolor',cols.k)
    ticklabels_new = cell(size(LabelsUS));
    for i = 1:length(LabelsUS)
        ticklabels_new{i} = ['\color{black} ' LabelsUS{i}];
    end
    % set the tick labels
    set(gca, 'XTickLabel', ticklabels_new,'FontSize',30,'FontName', 'Arial');
    % prepend a color for each tick label
    LabelsY = get(gca,'YTickLabel');
    ticklabels_ynew = cell(size(LabelsY));
    for i = 1:length(LabelsY)
        ticklabels_ynew{i} = ['\color{black} ' LabelsY{i}];
    end
    % set the tick labels
    set(gca, 'YTickLabel', ticklabels_ynew,'FontSize',30,'FontName', 'Arial');  
end  
    
    
    

if sample == 2
    
    %% US ratings classifier training experiment
    
    %valence 
    us_ratings = [results_classifier(:,2:3) results_classifier(:,4:5)];
    nanmean(us_ratings)
    nanstd(us_ratings)

    % repeated measures ANOVA on CS subjective value (pre-rating) 
    data = us_ratings;
    varNames = {'US1_pre','US2_pre','US1_post','US2_post'};

    t = array2table(data,'VariableNames',varNames);

    factorNames = {'stimulus', 'time'};
    within = table({'one'; 'one';'two';'two'},{'pre'; 'post';'pre';'post'},'VariableNames',factorNames);


    rm = fitrm(t,'US1_pre-US2_post~1','WithinDesign',within); 


    [ranovatbl] = ranova(rm, 'WithinModel', 'stimulus*time');

    disp('rmANOVA on US ratings')
    ranovatbl


    %calculate partial eta square 
    cp_data=data(:,1);
    time = [repmat(1,length(cp_data),1);repmat(2,length(cp_data),1);repmat(1,length(cp_data),1);repmat(2,length(cp_data),1)];
    stimulus = [repmat(1,length(cp_data),1);repmat(1,length(cp_data),1);repmat(2,length(cp_data),1);repmat(2,length(cp_data),1)];
    data_rm = [data(:,1); data(:,2); data(:,3); data(:,4)];

    mes2way(data_rm,[time stimulus],'partialeta2','isDep',[1 1])

    %Intensity
    us_ratings_int = [results_classifier(:,6:7) results_classifier(:,8:9)];
    nanmean(us_ratings_int)
    nanstd(us_ratings_int)

    % repeated measures ANOVA on CS subjective value (pre-rating) 
    data = us_ratings_int;
    varNames = {'US1_pre','US2_pre','US1_post','US2_post'};

    t = array2table(data,'VariableNames',varNames);

    factorNames = {'stimulus', 'time'};
    within = table({'one'; 'one';'two';'two'},{'pre'; 'post';'pre';'post'},'VariableNames',factorNames);


    rm = fitrm(t,'US1_pre-US2_post~1','WithinDesign',within); 


    [ranovatbl] = ranova(rm, 'WithinModel', 'stimulus*time');

    disp('rmANOVA on US ratings')
    ranovatbl


    %calculate partial eta square 
    cp_data=data(:,1);
    time = [repmat(1,length(cp_data),1);repmat(2,length(cp_data),1);repmat(1,length(cp_data),1);repmat(2,length(cp_data),1)];
    stimulus = [repmat(1,length(cp_data),1);repmat(1,length(cp_data),1);repmat(2,length(cp_data),1);repmat(2,length(cp_data),1)];
    data_rm = [data(:,1); data(:,2); data(:,3); data(:,4)];

    mes2way(data_rm,[time stimulus],'partialeta2','isDep',[1 1])

    
    
end

if sample == 3
    %% decoding accuracy split up for groups (non-parametric not possible for unbalanced groups --> 
    [h,p,ci,stats] = ttest2(decoding(decoding(:,4)==0,3),decoding(decoding(:,4)==1,3))

    %low (SOC) bias group
    [P,H,STATS] = signrank(decoding(decoding(:,4)==0,3), 0.5)
    %effect size
    mes(decoding(decoding(:,4)==0,3),0.5,'U3_1') 
    1-ans.U3_1

    %high (SOC) bias group
    [P,H,STATS] = signrank(decoding(decoding(:,4)==1,3), 0.5)
    mes(decoding(decoding(:,4)==1,3),0.5,'U3_1') 
    1-ans.U3_1


    %ES connectivity
    load('/Users/lennart/Desktop/savage/left_HC_MTL_conn_meants.txt')
    [P,H,STATS] = signrank(left_HC_MTL_conn_meants, 0)

    mes(left_HC_MTL_conn_meants,0,'U3_1') 
    1-ans.U3_1

end


