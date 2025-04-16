% behavior analysis
clear

load("behavior_trialinfo.mat")

num_subject = length(trialinfo);
trialinfo_all = trialinfo;
ntrial_total = zeros(num_subject,3); % # of total trial, recalled trial, non-recalled trial


% # of total trial, recalled trial, non-recalled trial
ntrial_total_positive = zeros(num_subject,3); % pre-defined positive words
ntrial_total_negative = zeros(num_subject,3); % pre-defined negative words

ntrial_valence_positive = zeros(num_subject,3); % self-evaluated positive words
ntrial_valence_negative = zeros(num_subject,3); % self-evaluated negative words
ntrial_valence_null = zeros(num_subject,3); % self-evaluated neutral words


ntrial_recall = zeros(num_subject,1); % number of recalled words


ntrial_correct_valence = zeros(num_subject,3); % consistent judgement of valence with pre-defined labels
ntrial_correct_positive = zeros(num_subject,3); % consistent judgement of positive words
ntrial_correct_negative = zeros(num_subject,3); %consistent judgement of negative words

ntrial_valence_positive_scale = zeros(num_subject,3,3); % self-evaluated positive with different scales +1,+2,+3
ntrial_valence_negative_scale = zeros(num_subject,3,3);% self-evaluated positive with different scales -1,-2,-3
ntrial_arousal_high = zeros(num_subject,3); % high-intensity judgement +2,+3,-2,-3
ntrial_arousal_low = zeros(num_subject,3); %low-intensity judgement +1,0,-1

ntrial_encoding_sequence = zeros(num_subject,10,3); % # of total words, recalled words, non-recalled words at different serial position

for sbj = 1 : num_subject


    ntrial_total(sbj,1) = height(trialinfo_all{sbj});
   
    for i = 1: 9
        ntrial_encoding_sequence(sbj,i,1) = length(find(mod(trialinfo_all{sbj}.trial_num,10)==i));
    end
    ntrial_encoding_sequence(sbj,10,1) = length(find(mod(trialinfo_all{sbj}.trial_num,10)==0));

    index_positive = find(strcmp(trialinfo_all{sbj}.valence,'positive'));
    ntrial_total_positive(sbj,1) = length(index_positive);

    index_valence_positive = find(strcmp(trialinfo_all{sbj}.SelfValence,'positive'));
    ntrial_valence_positive(sbj,1) = length(index_valence_positive);
    index_valence_negative = find(strcmp(trialinfo_all{sbj}.SelfValence,'negative'));
    ntrial_valence_negative(sbj,1) = length(index_valence_negative);

    ntrial_valence_positive_scale(sbj,1,1) = length(find(trialinfo_all{sbj}.emo_rate == 5));
    ntrial_valence_positive_scale(sbj,2,1) = length(find(trialinfo_all{sbj}.emo_rate == 6));
    ntrial_valence_positive_scale(sbj,3,1) = length(find(trialinfo_all{sbj}.emo_rate == 7));

    ntrial_valence_negative_scale(sbj,1,1) = length(find(trialinfo_all{sbj}.emo_rate == 3));
    ntrial_valence_negative_scale(sbj,2,1) = length(find(trialinfo_all{sbj}.emo_rate == 2));
    ntrial_valence_negative_scale(sbj,3,1) = length(find(trialinfo_all{sbj}.emo_rate == 1));

    ntrial_arousal_high(sbj,1) = length(find(trialinfo_all{sbj}.emo_rate >= 6|trialinfo_all{sbj}.emo_rate <= 2));
    ntrial_arousal_low(sbj,1) = length(find(trialinfo_all{sbj}.emo_rate < 6 & trialinfo_all{sbj}.emo_rate > 2));


    for itrial = 1 : height(trialinfo_all{sbj})
        if strcmp(trialinfo_all{sbj}.SelfValence{itrial},trialinfo_all{sbj}.valence{itrial})
            ntrial_correct_valence(sbj,1) = ntrial_correct_valence(sbj,1) + 1;
            if strcmp(trialinfo_all{sbj}.SelfValence{itrial},'positive')
                ntrial_correct_positive(sbj,1) = ntrial_correct_positive(sbj,1) + 1;
            else
                ntrial_correct_negative(sbj,1) = ntrial_correct_negative(sbj,1) + 1;
            end
        end
    end

    index_recall = find(strcmp(trialinfo_all{sbj}.recalled,'recall'));
    ntrial_recall(sbj,1) = length(index_recall);

    trialinfo_recall = trialinfo_all{sbj}(index_recall,:);
    ntrial_total(sbj,2) = height(trialinfo_recall);


    for i = 1: 9
        ntrial_encoding_sequence(sbj,i,2) = length(find(mod(trialinfo_recall.trial_num,10)==i));
    end
    ntrial_encoding_sequence(sbj,10,2) = length(find(mod(trialinfo_recall.trial_num,10)==0));

    ntrial_encoding_sequence(sbj,:,3) = ntrial_encoding_sequence(sbj,:,1) - ntrial_encoding_sequence(sbj,:,2);

    index_positive = find(strcmp(trialinfo_recall.valence,'positive'));
    ntrial_total_positive(sbj,2) = length(index_positive);

    index_recall_valence_positive = find(strcmp(trialinfo_recall.SelfValence,'positive'));
    ntrial_valence_positive(sbj,2) = length(index_recall_valence_positive);
    index_recall_valence_negative = find(strcmp(trialinfo_recall.SelfValence,'negative'));
    ntrial_valence_negative(sbj,2) = length(index_recall_valence_negative);

    ntrial_valence_positive_scale(sbj,1,2) = length(find(trialinfo_recall.emo_rate == 5));
    ntrial_valence_positive_scale(sbj,2,2) = length(find(trialinfo_recall.emo_rate == 6));
    ntrial_valence_positive_scale(sbj,3,2) = length(find(trialinfo_recall.emo_rate == 7));

    ntrial_valence_negative_scale(sbj,1,2) = length(find(trialinfo_recall.emo_rate == 3));
    ntrial_valence_negative_scale(sbj,2,2) = length(find(trialinfo_recall.emo_rate == 2));
    ntrial_valence_negative_scale(sbj,3,2) = length(find(trialinfo_recall.emo_rate == 1));

    ntrial_arousal_high(sbj,2) = length(find(trialinfo_recall.emo_rate >= 6|trialinfo_recall.emo_rate <= 2));
    ntrial_arousal_low(sbj,2) = length(find(trialinfo_recall.emo_rate < 6 & trialinfo_recall.emo_rate > 2));



    for itrial = 1 : height(trialinfo_recall)
        if strcmp(trialinfo_recall.SelfValence{itrial},trialinfo_recall.valence{itrial})
            ntrial_correct_valence(sbj,2) = ntrial_correct_valence(sbj,2) + 1;
            if strcmp(trialinfo_recall.SelfValence{itrial},'positive')
                ntrial_correct_positive(sbj,2) = ntrial_correct_positive(sbj,2) + 1;
            else
                ntrial_correct_negative(sbj,2) = ntrial_correct_negative(sbj,2) + 1;
            end
        end
    end
end

ntrial_total(:,3) = ntrial_total(:,1) - ntrial_total(:,2);
ntrial_total_positive(:,3) = ntrial_total_positive(:,1) - ntrial_total_positive(:,2);
ntrial_total_negative = ntrial_total - ntrial_total_positive;

ntrial_valence_negative_scale(:,:,3) = ntrial_valence_negative_scale(:,:,1) - ntrial_valence_negative_scale(:,:,2);
ntrial_valence_positive_scale(:,:,3) = ntrial_valence_positive_scale(:,:,1) - ntrial_valence_positive_scale(:,:,2);

ntrial_valence_positive(:,3) = ntrial_valence_positive(:,1) - ntrial_valence_positive(:,2);
ntrial_valence_negative(:,3) = ntrial_valence_negative(:,1) - ntrial_valence_negative(:,2);

ntrial_arousal_high(:,3) = ntrial_arousal_high(:,1) - ntrial_arousal_high(:,2);
ntrial_arousal_low(:,3) = ntrial_arousal_low(:,1) - ntrial_arousal_low(:,2);

ntrial_correct_valence(:,3) = ntrial_correct_valence(:,1) - ntrial_correct_valence(:,2);
ntrial_correct_positive(:,3) = ntrial_correct_positive(:,1) - ntrial_correct_positive(:,2);
ntrial_correct_negative(:,3) = ntrial_correct_negative(:,1) - ntrial_correct_negative(:,2);

ntrial_valence_null = ntrial_total - ntrial_valence_positive - ntrial_valence_negative;

ratio_arousal_high = ntrial_arousal_high./ntrial_total;
ratio_arousal_low = ntrial_arousal_low./ntrial_total;

ratio_valence_positive = ntrial_valence_positive./ntrial_total;
ratio_valence_negative = ntrial_valence_negative./ntrial_total;
ratio_valence_null = ntrial_valence_null./ntrial_total;


ratio_prelabel_positive = ntrial_total_positive./ntrial_total;
ratio_prelabel_negative = ntrial_total_negative./ntrial_total;

ratio_correct_valence = ntrial_correct_valence./ntrial_total;
ratio_correct_positive = ntrial_correct_positive./ntrial_total_positive;
ratio_correct_negative = ntrial_correct_negative./ntrial_total_negative;


ratio_encoding_sequence = ntrial_encoding_sequence(:,:,2)./ntrial_encoding_sequence(:,:,1);

ntrial_total_3d = permute(ntrial_total,[1,3,2]);
ntrial_total_3d = repmat(ntrial_total_3d,[1,3,1]);


ratio_valence_positive_scale = ntrial_valence_positive_scale./ntrial_total_3d;%sum(ntrial_valence_positive_scale,2);
ratio_valence_negative_scale = ntrial_valence_negative_scale./ntrial_total_3d;%sum(ntrial_valence_negative_scale,2);

ratio_recall = ntrial_recall./ntrial_total(:,1);

%%
% compare ratio of positive judgement vs. negative judgement
[h_val,p_val,~,  stats_val] = ttest(ratio_valence_positive(:,1),ratio_valence_negative(:,1));


% compare ratio of consistent judgement of valence with the pre-defined label (positive vs. negative) 
[h_acc,p_acc, ~, stats_acc] = ttest(ratio_correct_positive(:,1),ratio_correct_negative(:,1));

% compare ratio of high-intensity judgement vs. low-intensity judgement
[h_arousal,p_arousal,~,  stats_arousal] = ttest(ratio_arousal_high(:,1),ratio_arousal_low(:,1));



ratio_recall_prelabel_positive = ntrial_total_positive(:,2)./ntrial_total_positive(:,1);
ratio_recall_prelabel_negative = ntrial_total_negative(:,2)./ntrial_total_negative(:,1);
ratio_recall_positive = ntrial_valence_positive(:,2)./ntrial_valence_positive(:,1);
ratio_recall_negative = ntrial_valence_negative(:,2)./ntrial_valence_negative(:,1);
ratio_recall_high = ntrial_arousal_high(:,2)./ntrial_arousal_high(:,1);
ratio_recall_low = ntrial_arousal_low(:,2)./ntrial_arousal_low(:,1);

% recall rate high vs. low intensity
[h_recallaro,p_recallaro, ~, stats_recallaro] = ttest(ratio_recall_high,ratio_recall_low);

% recall rate self-evaluated positive vs. negative
[h_recallval,p_recallval, ~, stats_recallval] = ttest(ratio_recall_positive,ratio_recall_negative);

% recall rate pre-defined positive vs. negative
[h_recallpreval,p_recallpreval, ~, stats_recallpreval] = ttest(ratio_recall_prelabel_positive,ratio_recall_prelabel_negative);


% primacy effect and recency effect 
ratio_start = ratio_encoding_sequence(:,1);
ratio_end = ratio_encoding_sequence(:,10);
ratio_middle= mean(ratio_encoding_sequence(:,[5:6]),2);

[h_start,p_start,~,stat_start] = ttest(ratio_start,ratio_middle);
[h_end,p_end,~,stat_end] = ttest(ratio_end,ratio_middle);
%Bon-corrected
p_end = p_end*2;
p_start = p_start*2;



%% RT comparison at subject level

% recalled vs. non-recalled
[h_rt1ef,p_rt1ef,~,stats_rt1ef] = ttest(stats_table_emo_resp.mean_RT_encoded,stats_table_emo_resp.mean_RT_forgotten);

% self-evaluated positive vs. negative
[h_rt1selfpn,p_rt1selfpn,~,stats_rt1selfpn] = ttest(stats_table_emo_resp.mean_RT_selfpositive,stats_table_emo_resp.mean_RT_selfnegative);

% pre-defined positive vs. negative
[h_rt1pn,p_rt1pn,~,stats_rt1pn] = ttest(stats_table_emo_resp.mean_RT_positive,stats_table_emo_resp.mean_RT_negative);

% high vs. low intensity
[h_rt1hl,p_rt1hl,~,stats_rt1hl] = ttest(stats_table_emo_resp.mean_RT_higharousal,stats_table_emo_resp.mean_RT_lowarousal);

