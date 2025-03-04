% indentify selective insular sites during the encoding

clear

% prepare data
% trialinfo: table containing information about each trial
% act: exponent values during the encoding phase - ntrials*1
% base: exponent values during the baseline periods - ntrials*1

nperm = 5000;


% find the index of recalled and non-recalled trials
index_recalled = find(strcmp(trialinfo.appro_recalled,'recall'));
index_forgotten = find(strcmp(trialinfo.appro_recalled,'miss'));
[min_sample,index] = min([length(index_recalled),length(index_forgotten)]);
if index == 1
    fixed_index = index_recalled;
    random_index = index_forgotten;
else
    random_index = index_recalled;
    fixed_index = index_forgotten;
end
outer_t = nan(1,nperm);
outer_p = nan(1,nperm);
outer_perm_t = nan(1,nperm);
outer_perm_p = nan(1,nperm);


parfor r = 1:nperm
    tmp_index = randperm(length(random_index));
    % select the balance number of samples between recalled and non-recalled trials 
    selected_index = [random_index(tmp_index(1:min_sample));fixed_index(:)];
    outer_perm_mean_act = act(selected_index);
    outer_perm_mean_base = base(selected_index);
    [h,p,ci,stats] = ttest(outer_perm_mean_act,outer_perm_mean_base);
    outer_t(r) = stats.tstat;
    outer_p(r) = p;

    dat_tot = cat(1,outer_perm_mean_act,outer_perm_mean_base);

    rand_ind = randperm(length(dat_tot));
    dat_rand = dat_tot(rand_ind,:,:);

    [h,p,ci,stats] = ttest(dat_rand(1:(length(dat_tot)/2),:),dat_rand(((length(dat_tot)/2)+1):end,:));
    outer_perm_t(r) = squeeze(stats.tstat);
    outer_perm_p(r) = p;
end


true_t = mean(outer_t);

if(true_t>0)
    perm_t = outer_perm_t;
    p_perm = 1- sum(perm_t<true_t)/nperm;
else
    perm_t = outer_perm_t;
    p_perm = 1- sum(perm_t>true_t)/nperm;
end



