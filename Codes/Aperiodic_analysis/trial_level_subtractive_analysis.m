% measure changes in the exponent of the aperiodic activity at the single trial basis and
% compared the measures of the exponent across two conditions of interest in two dimensions of
% memory and valence

clear

% prepare data
% trialinfo: table containing information about each trial
% act_exp: exponent values during the encoding phase - ntrials*1

nperm = 5000;

% only include high-intensity trials
high_index = find(trialinfo.emo_rate>5|trialinfo.emo_rate<3);
trialinfo = trialinfo(high_index,:);
act_exp = act_exp(high_index);
if strcmp(comp_type,'memory')
    index_1 = find(strcmp(trialinfo.appro_recalled,'recall'));
    index_2 = find(strcmp(trialinfo.appro_recalled,'miss'));

elseif strcmp(comp_type,'valence')
    index_1 = find(strcmp(trialinfo.valence,'positive'));
    index_2 = find(strcmp(trialinfo.valence,'negative'));

end
ntrial(1) = length(index_1);
ntrial(2) = length(index_2);
act_1 = act_exp(index_1);
act_2 = act_exp(index_2);

[min_sample,min_index] = min(ntrial);
[max_sample,max_index] = max(ntrial);
if min_index == max_index
    min_index = 3-max_index;
end
true_t = nan(1,nperm);
true_p = nan(1,nperm);
outer_perm_t = nan(1,nperm);
outer_perm_p = nan(1,nperm);


for r = 1:nperm

    tmp_index = randperm(max_sample);
    selected_index = tmp_index(1:min_sample);
    conditions_exp = nan(min_sample,2);
    if ntrial(1)>ntrial(2)
        conditions_exp(:,1) = act_1(selected_index);
        conditions_exp(:,2) = act_2;
    else
        conditions_exp(:,1) = act_1;
        conditions_exp(:,2) = act_2(selected_index);
    end

    [h,p,ci,stats] = ttest2(conditions_exp(:,1),conditions_exp(:,2));
    true_t(r) = stats.tstat;
    true_p(r) = p;

    dat_tot = conditions_exp(:);

    rand_ind = randperm(length(dat_tot));
    dat_rand = dat_tot(rand_ind,:,:);

    [h,p,ci,stats] = ttest2(dat_rand(1:(length(dat_tot)/2),:),dat_rand(((length(dat_tot)/2)+1):end,:));
    outer_perm_t(r) = squeeze(stats.tstat);
    outer_perm_p(r) = p;


end

true_t = mean(true_t);

if(true_t>0)
    perm_t = outer_perm_t;

    p_perm(iele) = 1- sum(perm_t<true_t)/nperm;
else
    perm_t = outer_perm_t;

    p_perm(iele) = 1- sum(perm_t>true_t)/nperm;
end
