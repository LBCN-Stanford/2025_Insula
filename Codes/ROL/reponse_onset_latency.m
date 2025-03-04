clear

%% ------------------1. Prepare Data----------------------------

%{
Data format: Struct with the following fields (data):
Wave: actual data - trials x chan x time
ROI_table: table with electrode information
fsample: sampling rate of the data
chans: 1 x #chans cell array with channel names
ROI_type: 1 x #chans cell array with anatomical label of channel (could be
            changed or removed for your analysis
time: 1 x npoints vector containing trial time definition
elinfo: redundant information from ROI table to be saved in the ROL table
        for easy future analysis (this can be changed in the code)
trialinfo: table containing information about each trial
by James Stieger
jstieger@stanford.edu
%}


%% ------------------2. Generate parameters for ROL analysis----------------------------

% Prepare data for channel table script
%find mean expected value for a randomly selected 300ms window

win_len = .3;
num_pnts = win_len*data.fsample;
max_t = length(data.time) - (num_pnts + 1);
max_trial = height(trialinfo);
feature_wave = data.wave;
nperm = 100000;
rand_wins = zeros(1,nperm);%find a unique distribution for each channel
parfor r = 1:nperm
    trial = randi(max_trial);
    rand_t = randi(max_t);
    time_vec = rand_t:(rand_t + num_pnts);
    rand_wins(r) = squeeze(nanmean(feature_wave(trial,time_vec),2));
end

%get the threshold for each channel - defined as 2std above
%mean value for a 300 ms window
thresh_val = nanmean(rand_wins) + 2.*nanstd(rand_wins);

%set up parameters
%min ROL - what is the minimum time we should start looking for
%significant events? Vector: ntrials x 1
min_rol = zeros(height(trialinfo),1);
%max ROL - what is the maximum time when we should stop looking for
%significant events? Vector: ntrials x 1
max_rol = 2.5*ones(height(trialinfo),1); %when participant responds


%% ------------------3. Create ROL table ----------------------------


%prep data to send to function

data = wave;
thresh = thresh_val;
time = time;
fsample = fsample;
max_rol = max_rol;
min_rol = min_rol;
trialinfo = trialinfo;
%run ROL analysis

chan_table = cascadeROLChanTableRT_new(data,thresh,time,fsample,min_rol,max_rol,trialinfo);


