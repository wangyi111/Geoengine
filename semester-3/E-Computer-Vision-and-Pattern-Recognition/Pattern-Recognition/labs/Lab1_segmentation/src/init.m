global PATH2DATA
global PATH2REPORTS
global d_GT
global d_nDSM
global d_RGBIR

% Add subpaths to search path:
addpath(genpath('.'));

format compact;

% Init globals:
PATH2DATA    = '../data';
PATH2REPORTS = '../reports';

% Init data sources:
d_nDSM  = data.potsdam.ImageSource('1_DSM_normalisation', 'dsm_potsdam_%02d_%02d_normalized_lastools.jpg');
d_RGBIR = data.potsdam.ImageSource('4_Ortho_RGBIR',       'top_potsdam_%d_%d_RGBIR.tif');
d_GT    = data.potsdam.ImageSource('5_Labels_all',        'top_potsdam_%d_%d_label.tif');
