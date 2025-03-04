# -*- coding: utf-8 -*-



import numpy as np
import os
import sys

from fooof import FOOOFGroup
from scipy.io import loadmat
from scipy.io import savemat

#python command line should include subject name, block_name, chan_name
print(sys.argv)
sbj_name = sys.argv[1] 
block_name = sys.argv[2]
chan_num = sys.argv[3]

# Define the data path and file name

data_path = r'H:\data\FoooFSpectra'

#prepare path dictionary
path = {'main_dir': os.path.join(data_path,sbj_name,''),
}

print(f'running {sbj_name}: {block_name} chan {chan_num}...')
load_path = os.path.join(path['main_dir'],block_name,'')
load_fn = f'{load_path}iEEG_{block_name}_MASpec_{chan_num}.mat'
save_fn = f'{load_path}iEEG_{block_name}_fooof_{chan_num}.mat'

#check if it exists
if os.path.exists(save_fn):
    print(f'{sbj_name}: {block_name} chan {chan_num} exists, moving on...')
    sys.exit()

# Load the data
data = loadmat(load_fn)

# Convert MATLAB arrays to numpy arrays
freqs = np.array(data['freqs'][0])  # assuming 'freqs' is stored as a row vector in the .mat file
spectrum = np.array(data['spectrum'])  # 'spectrum' is directly converted into a numpy array

#run fooof
fg = FOOOFGroup(peak_width_limits=[1, 20], max_n_peaks=6, min_peak_height=0)

# if conduct knee detection
# fg = FOOOFGroup(peak_width_limits=[1, 20], max_n_peaks=6, min_peak_height=0, aperiodic_mode='knee')

# Set the frequency range to fit the model
freq_range = [1, 120]

# Report: fit the model, print the resulting parameters, and plot the reconstruction
fg.fit(freqs, spectrum.T, freq_range)

### Get the parameters ####
# Extract aperiodic parameters
exps = fg.get_params('aperiodic_params', 'exponent')
offs = fg.get_params('aperiodic_params', 'offset')

# Extract peak parameters
peaks = fg.get_params('peak_params')
gauss = fg.get_params('gaussian_params')

# get the knee frequency
# knee = fg.get_params('aperiodic_params', 'knee')
# knee_frequency = knee ** (1. / exps)


#save the data
# Put variables into dictionary
save_data = {'exps': exps,
        'offs': offs,
        'peaks': peaks,
        'gauss': gauss}

# Save the data
savemat(save_fn, save_data)

