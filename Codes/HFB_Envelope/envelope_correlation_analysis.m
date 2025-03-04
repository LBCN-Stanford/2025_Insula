clear
data_root = './HFB_envelope';
output_root = './HFB_envelope_corr';


subject_names =  {'S21_172_KS','S22_177_JM',...
    'S22_183_CR','S22_185_TW','S22_190_AS','S22_191_KM','S23_199_GB','S23_201_JG',...
    'S23_205_LLC','S23_207_SO','S23_211_SS','S23_212_JM'};   %

% nsec_crop: seconds to crop to avoid edge artifacts.
nsec_crop = 50;
fs = 500;


for sbj = 1 : length(subject_names)
    sbj_name = subject_names{sbj};
    if ~exist(fullfile(output_root,sbj_name))
        mkdir(fullfile(output_root,sbj_name));
    end
    tmp_names = dir(fullfile(data_root,sbj_name,'E*'));
    block_names = {tmp_names.name};

    for blk = 1 : length(block_names)
        blk_name = block_names{blk};
        corr_table = [];
        tmp = load(fullfile(data_root,sbj_name,blk_name,['HFB_envelope_INSULA.mat']));
        ins_table = tmp.electrode_table;
        tmp = load(fullfile(data_root,sbj_name,blk_name,['HFB_envelope_HPC.mat']));
        hpc_table = tmp.electrode_table;
        for iele_ins = 1 : height(ins_table)
            if ins_table.chan_loc(iele_ins,1)<0
                hemi_ins = 'L';
            else
                hemi_ins = 'R';
            end
            for iele_hpc = 1 : height(hpc_table)
                if hpc_table.chan_loc(iele_hpc,1)<0
                hemi_hpc = 'L';
            else
                hemi_hpc = 'R';
            end
            if hemi_ins~=hemi_hpc
                continue;% only include ipsilateral pairs
            end
            tmp_table = [];
            tmp_table.chan_index_ins = ins_table.chan_index(iele_ins);
            tmp_table.chan_name_ins = ins_table.chan_names{iele_ins};
            tmp_table.chan_loc_ins = ins_table.chan_loc(iele_ins,:);
            tmp_table.hemi_ins = hemi_ins;
            tmp_table.chan_index_hpc = hpc_table.chan_index(iele_hpc);
            tmp_table.chan_name_hpc = hpc_table.chan_names{iele_hpc};
            tmp_table.chan_loc_hpc = hpc_table.chan_loc(iele_hpc,:);
            tmp_table.hemi_hpc = hemi_hpc;

                time_index = hpc_table.time{iele_hpc};
                crop_s = max(find(nsec_crop>time_index));
                time_index = time_index(crop_s:end-crop_s);
                data_hpc = hpc_table.envelope{iele_hpc}(crop_s:end-crop_s);
                data_ins = ins_table.envelope{iele_ins}(crop_s:end-crop_s);

                corr_index = corr(data_ins(:),data_hpc(:));
             

                tmp_table.corr_coef = corr_index;

                corr_table = [corr_table;tmp_table];
            end%iele_hpc
        end%iele_ins
        corr_table = struct2table(corr_table);
        savename = fullfile(output_root,sbj_name,['corr_table_' blk_name]);
        save(savename,'corr_table')
    end%blk

end%sbj


