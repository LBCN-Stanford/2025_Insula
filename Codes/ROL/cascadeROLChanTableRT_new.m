function ROL_table = cascadeROLChanTableRT_new(data,thresh,time,fsample,min_rol,max_rol,trialinfo)

% input 
% data: actual data - trials x time
% trialinfo: table containing information about each trial
% time: 1 x npoints vector containing trial time definition
% fsample: sampling rate of the data
%% Compute ROL separately for each channel

%parameters
win_len = .1;
num_pnts = win_len*fsample;

if height(data)~=height(trialinfo)
    error('trial mismatch')
end

ROL_table = [];

for trial = 1:height(data)
    
    %narrow down time and data to fit into selected window
    valid_ind_time = find(time >= min_rol(trial) & time <= max_rol(trial));
    tmp_time = time(valid_ind_time);
    
    trial_dat = data(trial,valid_ind_time);
    
    %plot 1
    %{
    figure('units', 'normalized', 'outerposition', [0,0,1,1])
    plot(tmp_time,trial_dat,'color',[0.7,0.7,0.7])
    hold on
    plot(tmp_time,thresh.*ones(size(tmp_time)),'r')
    title(['Trial: ',num2str(trial)])
    %}
    
    trial_dat = movmean(trial_dat,num_pnts);
    
    %plot 2
    %plot(tmp_time,trial_dat,'b')
    
    trial_bool = trial_dat > thresh;
    CC = bwconncomp(trial_bool);
    events = CC.PixelIdxList;
    
    %find events longer than min duration
    valid_ind = find(cell2mat(cellfun(@(x) length(x)>num_pnts,events,'UniformOutput',0)));
    
    if isempty(valid_ind)
        %pause
        %close all
        continue
    else
        for e = 1:length(valid_ind)

            event_ind = events{valid_ind(e)}; %take event with greatest mean

            %plot 4
            %plot(tmp_time(event_ind),trial_dat(event_ind),'g','LineWidth',2)
            
            %get 100ms windows to examine
            win_min = max(1,event_ind(1) - 2.*num_pnts);
            win_max = min(event_ind(1) + num_pnts,length(tmp_time));
            
            %get 100ms moving windows
            win_tot = win_min:(win_max);
            winlength = num_pnts;
            overlap = round(winlength*0.9);
            
            %get moving window index with overlap
            lx=length(win_tot);
            win_index = spdiags(repmat((1:lx)',[1 winlength]),0:-(winlength-overlap):-lx+winlength);
            
            %find slope and error
            slopes = zeros(size(win_index,2),1);
            errors = zeros(size(win_index,2),1);
            
            for win = 1:size(win_index,2)
                x = tmp_time(win_tot(win_index(:,win)))';
                y = trial_dat(win_tot(win_index(:,win)))';
                [b,~,r] = regress(y,[ones(size(x)),x]);
                %{
                figure
                plot(x,y)
                hold on
                plot(x,x.*b(2) + b(1));
                %}
                slopes(win) = b(2);
                errors(win) = sum((y - r).^2);
            end
            
            %rank slopes and take 5 steepest
            [r,i] = sort(slopes,'descend');
            top_num = min(length(slopes),5);
            i = i(1:top_num);
            i = i(slopes(i) > 0);
            if isempty(i)
                %pause
                %close all
                continue
            end
            
            %find window with smallest error
            [~,min_ind] = min(errors(i));
            rol_ind = win_tot(win_index(1,i(min_ind)));
            
            %plot 5
            %{
            plot(tmp_time(rol_ind),trial_dat(rol_ind),'.','MarkerSize',30,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor',[0,0,0])
            ylm = ylim;
            plot([tmp_time(rol_ind),tmp_time(rol_ind)],[ylm(1),ylm(2)],'k','LineWidth',0.5)
            %}
            
            rol = tmp_time(rol_ind) - min_rol(trial);
            trial_num = trial;
            event_lims = [tmp_time(event_ind(1)),tmp_time(event_ind(end))];
            
            %concatinate tables

            trial_tbl = table(trial_num,rol,event_lims);

            ROL_table = cat(1,ROL_table,trial_tbl);
            
        end%for e: detected events
        
        %pause
        %close all
    end%if valid ind empty
    
end%for trails

end%function main
