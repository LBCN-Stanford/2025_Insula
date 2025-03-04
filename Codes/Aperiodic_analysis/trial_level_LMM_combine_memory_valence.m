% LMM for combination of memory and valence effects on each single site
% LMM was performed with one fator as main effect and the other as a covariate


% prepare data
% trialinfo: table containing information about each trial
% exp: exponent values during the encoding phase - ntrials*1


ntrial = height(trialinfo);
factor_memory = zeros(ntrial,1);
factor_valence = zeros(ntrial,1);
factor_arousal = zeros(ntrial,1);
for itrial = 1 : ntrial
    if trialinfo.emo_rate(itrial)>=3 & trialinfo.emo_rate(itrial)<=5
        factor_arousal(itrial) = 0;
    else
        factor_arousal(itrial) = 1;
    end
    if strcmp(trialinfo.appro_recalled{itrial},'recall')
        factor_memory(itrial) = 1;
    else
        factor_memory(itrial) = 0;
    end
    if strcmp(trialinfo.valence{itrial},'positive')
        factor_valence(itrial) = 1;
    else
        factor_valence(itrial) = 0;
    end
end
% only include high intensity trials
high_index = find(factor_arousal==1);

data = table(factor_memory,factor_valence,exp);
data = data(high_index,:);
model = fitlm(data, 'exp ~ factor_memory + factor_valence');


beta_memory = model.Coefficients.Estimate('factor_memory');
beta_valence = model.Coefficients.Estimate('factor_valence');

p_memory = model.Coefficients.pValue('factor_memory');
p_valence = model.Coefficients.pValue('factor_valence');


