% full patch analysis
%    [analysis] = analyzePatches(m2file, roifile, zoom, scope, pars)
% lasted updated 2018/9/18 on thermaltake

function [allresults] = analyze_patchiness(m2file, comparison_file, roifile, baselineFile, zoom, scope)

%% select files
% m2file = '15157_s1_Venus_x3_2_cropped1.tif';
% comparison_file = '15157_s1_tdT_x3_2_cropped1.tif';
% roifile = [];
% baselineFile = '15157_s1_Venus_x3_2_cropped1_baseline_area.tif';
% zoom = 3.2; 

m2file = '18071_s2_lgn_x10.tif';
comparison_file = '18071_s3_VGAT_x10_aligned_to_s2.tif';
roifile = '18071_s3_VGAT_x10_aligned_to_s2_roi_area.tif';
% roi= [];
baselineFile = '18071_s3_VGAT_x10_aligned_to_s2_baseline_area.tif';
zoom = 10;

% scope = 'epimicro_old';
scope = 'epimicro'; 



%% output and plotting - does not affect quantitative analysis
fig_pars.show_plots = 1; % show m2 and comparison images with patch and interpatch borders
fig_pars.patch_border_width = 20; %%% width of patch borders 
fig_pars.patch_border_color= [.5, 1, 1]; % use either an RGB triplet or one of the following strings: r/red, g/green, b/blue, y/yellow, m/magenta, c/cyan, w/white, k/black, none
fig_pars.interpatch_border_width = 1; %%% width of patch borders 
fig_pars.interpatch_border_color= [.1 .5 .8]; 
save_output = 0; % save the results in a filename with name specified in output_filename
    output_filename = 'temp.mat';



%% patch-finding params
% patches will be automatically found by blurring and threshold pixel intensity in the m2file image
findpatches_pars.threshMode = 'intensityQuantiles';
    findpatches_pars.nQuantiles = 6;
    findpatches_pars.patchQuantiles = [5 6]; % quantiles selected to be counted as patches; higher numbers = brighter pixels; use [5 6] to match sincich and horton
findpatches_pars.diskblurradius_um = 29;
findpatches_pars.minAreaPatch_squm = 0;   % min area in square microns a blob must contain to be considered a patch
findpatches_pars.maxAreaPatch_squm = inf; 
findpatches_pars.blur_using_only_roi = 1; % if true, do not use non-roi pixels for blurring (should==1 if image has zeros/nans outside roi, such as for blood vessels/image borders)  
findpatches_pars.include_interior_nonroi_in_roi = 1; % include non-roi pixels completely contained within patches as part of the surrounding patch
do_patch_density_analysis = 0; % get statistics on patch spacing




%% permutation test params
% permutation test looks for significant differences in patches vs interpatches
%   by shuffling pixels in the image and comparing these randomized intensity distributions
%   to the actual patch vs interpatch distribution in the original images
permutation_pars.npermutations = 10000; % number of permutations; ?10,000 recommended to asymptote
permutation_pars.resample_pix = 1;  %%% resample pixels in proj image; set pixel area to resampled_pix_area_squm
    % at epi scope x3.2, 1 pixel area == 3.84 squm.... area of a 60um-radius patch == 3600 squm
    permutation_pars.resampled_pix_area_squm = 100; % area of a pixel in square microns after resampling
permutation_pars.normMethod ='subtractBaseline_divideByRoiMean';   
%     permutation_pars.normMethod = 'none';
%     permutation_pars.normMethod = 'divideByRoiMean';
permutation_pars.custom_interpatches = 1; % use something other than all non-patch pixels as interpatch pixels
    permutation_pars.interpatchQuantiles = [1 2]; % quantiles selected to be counted as interpatches, if custom_interpatches==true; lower numbers = darker pixels


%% perimeter test params
% perimeter test will look for significant differences in pixel intensity 
%   in patches vs. in a ring around each patch (considered to be the corresponding interpatch)
%   using a paired t-test
%%%%% NB: whatever area is considered to be interpatches in previous analyses will not match the interpatches used in the perimeter test
perimeter_pars.intptchThicknessUM = 30; % width of the ring to draw around patches to treat as interpatches
perimeter_pars.pars.min_area_patch_sqmm = 0; % minimum patch area to analyze a given patch as part of the perimeter test
% perimeter_pars.normMethod = 'subtractBaseline'; 
perimeter_pars.normMethod = 'subtractBaseline_divideByRoiMean'; % scale pixel intensity to average intensity within roi
% perimeter_pars.normMethod = 'subtractBaseline_divideByRoiMax'; % scale pixel intensity to max intensity within roi
% perimeter_pars.normMethod = 'subtractBaseline_divideByPatchesIntptchs'; % scale intensity to avg of patches and interpatches, not avg of ROI




%% perform analyses
patchiness_pipeline();
    

