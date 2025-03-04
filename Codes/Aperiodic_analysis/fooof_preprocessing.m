%%%%%
% convert smoothed spectrum into linear-sapced frequencies between 1 and
% 256 Hz with 150 total frequencies by linear interpolation
%

% prepare data
%{

Data format: Struct with the following fields (data):
Wave: actual data - frequency x time
fsample: sampling rate of the data
freqs: 1 * nfrequency vector containing freuqency definition
time: 1 x npoints vector containing time definition
%}

%get moving average of spectra
raw_wave = data.wave;
window_len = 0.5; % seconds
% Define the window length (in seconds)
% Calculate the number of samples in each window
window_samples = round(window_len * data.fsample);
% Initialize spectrum
spectrum = zeros(size(raw_wave));
% Calculate the moving average for each frequency
for i = 1:size(raw_wave, 1)
    spectrum(i, :) = movmean(raw_wave(i, :), window_samples);
end
%% Linear spacing
% Define new frequency range
freqs = data.freqs;
new_freqs = linspace(min(freqs), max(freqs), 150);
% Preallocate interpolated spectrum
interp_spectrum = zeros(length(new_freqs), size(spectrum, 2));
% Interpolate spectrum for each time point
for i = 1:size(spectrum, 2)
    interp_spectrum(:, i) = interp1(freqs, spectrum(:, i), new_freqs);
end

freqs = new_freqs;
spectrum = interp_spectrum;


