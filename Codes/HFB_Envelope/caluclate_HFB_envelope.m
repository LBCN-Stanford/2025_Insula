clear
% addpath(genpath('D:\Code\clinicalSYS\fieldtrip-20240504'))
addpath('D:\Code\clinicalSYS\fieldtrip-20240504\preproc')
data_root = 'R:\Data\DataAll\Resting\neuralData\BandData\HFB';
output_root = './HFB_envelope';

table_root = 'R:\Data\Spectrum\HFsignal';
subject_names =  {...};  


ROIs = {'HPC','INSULA'};

for sbj = 1 : length(subject_names)
    sbj_name = subject_names{sbj};
    
    tmp_names = dir(fullfile(data_root,sbj_name,'E*'));
    block_names = {tmp_names.name};
    for iroi = 1 : length(ROIs)
        roi = ROIs{iroi};
        tmp = load(fullfile(table_root,sbj_name,['HF_onsetlock_' sbj_name '_' roi '.mat']));
        ROI_table = tmp.roi_result_table;
        for blk = 1 : length(block_names)
            blk_name = block_names{blk};
            if ~exist(fullfile(output_root,sbj_name,blk_name))
                mkdir(fullfile(output_root,sbj_name,blk_name));
            end
            electrode_table = ROI_table;
            for iele = 1 : height(electrode_table)
                tmpdata = load(fullfile(data_root,sbj_name,blk_name,['HFBiEEG' blk_name '_' num2str(electrode_table.chan_index(iele),'%.2d') '.mat']));
                data = tmpdata.data;
                data_tpm = ft_preproc_bandpassfilter(data.wave, 1000, [0.1, 1], 4, 'but', 'twopass', 'reduce');

                electrode_table.time{iele} = data.time;
                electrode_table.envelope{iele} = data_tpm;
            end%iele
            savename = fullfile(output_root,sbj_name,blk_name,['HFB_envelope_' roi '.mat']);
            save(savename,'electrode_table')
        end%blk
       
    end%iroi
end%sbj





