%%% get mean pixel values within delineated areas of series of input images  
% input table with at least the following variables:
%   expossecs = exposure time; values will be converted to equivalent as if exposure time = 1s
%   projfile = image with pixel values to be averaged
%   areafile = image with white areas indicating ROI, other areas black  
%   baselineAreaFile = filename of BW image indicating baseline area; use projfile as intensity image  
%   
% struct 'baseline' for normalizing to baseline (will be ignored if there is baselinefile in intable):
%   baseline.baselineImage = filename of image to get baseline from
%   baseline.baseLineArea = filename of image in white indicating where to analyze baselineImage
%   baseline.expossecs = exposure time
%%%% last upated 8/24/17 

function outtable = areaDensity(intable,baseline)

nimages = height(intable);
outtable = intable;
outtable.roitotalpix = NaN(nimages,1);
outtable.intensPerPix = NaN(nimages,1);

for i = 1:nimages
     projimg = imread(outtable.projfile{i});
     projimg = projimg(:,:,1); % in case image is rgb, take only first channel
     roiimg = imread(outtable.areafile{i});
     roiimg = roiimg(:,:,1); % in case image is rgb, take only first channel
     
    % check whether area images have white pixels at borders, potentially
    % indicating image processing artifacts
    if any(find(roiimg(:,1))) || any(find(roiimg(:,end))) || any(find(roiimg(1,:))) || any(find(roiimg(end,:)))
        go_on = input(['Warning: patch area image ' outtable.areafile{i} ' has nonzero pixels along a border. Enter ''y'' to continue.'],'s');
        if ~strcmp(go_on,'y')
            error('quitting areaDensity')
        end
    end
    
    if any(size(projimg) ~= size(roiimg))
        error([outtable.projfile{i} ' and ' outtable.areafile{i} ' are different sizes.'])
    end
     
    roi_inds = find(roiimg);
    roi_vals = projimg(roi_inds);
    raw_roi_mean = mean(roi_vals);
    
    if any(strcmp('baselineAreaFile',intable.Properties.VariableNames)) % if using section-specific baseline
        baseAreaImg = imread(intable.baselineAreaFile{i});
        baseAreaImg = baseAreaImg(:,:,1); % in case image is rgb, take only first channel
        % check whether area image has white pixels at borders, potentially
        % indicating image processing artifacts
        if any(find(baseAreaImg(:,1))) || any(find(baseAreaImg(:,end))) || any(find(baseAreaImg(1,:))) || any(find(baseAreaImg(end,:)))
            go_on = input(['Warning: patch area image ' intable.baselineAreaFile{i} ' has nonzero pixels along a border. Enter ''y'' to continue.'],'s');
            if ~strcmp(go_on,'y')
                error('quitting areaDensity')
            end
        end
        baseAreaInds = find(baseAreaImg);
        baseVals = projimg(baseAreaInds);
        outtable.intensPerPixRaw(i) = raw_roi_mean / outtable.expossecs(i); % record raw val before subtracting baseline
        raw_roi_mean = raw_roi_mean - mean(baseVals); % subtract baseline
    end
    
    outtable.intensPerPix(i) = raw_roi_mean / outtable.expossecs(i); % normalize to simulated exposure time of 1s
    outtable.roitotalpix(i) = length(roi_inds);
    outtable.baseline(i) = outtable.intensPerPixRaw(i) - outtable.intensPerPix(i);
end

if exist('baseline','var') && ~any(strcmp('baselinefile',intable.Properties.VariableNames))
    baseimg = imread(baseline.baselineImage);
    baseimg = baseimg(:,:,1); % in case image is rgb, take only first channel
    baseAreaImg = imread(baseline.baselineAreaImage);
    baseAreaImg = baseAreaImg(:,:,1); % in case image is rgb, take only first channel
    % check whether area image has white pixels at borders, potentially
    % indicating image processing artifacts
    if any(find(baseAreaImg(:,1))) || any(find(baseAreaImg(:,end))) || any(find(baseAreaImg(1,:))) || any(find(baseAreaImg(end,:)))
        go_on = input(['Warning: patch area image ' baseline.baselineAreaImage ' has nonzero pixels along a border. Enter ''y'' to continue.'],'s');
        if ~strcmp(go_on,'y')
            error('quitting areaDensity')
        end
    end
    baseAreaInds = find(baseAreaImg);
    baseVals = baseimg(baseAreaInds);
    baselineVal = mean(baseVals) / baseline.expossecs;
    outtable.intensPerPixRaw = outtable.intensPerPix;
    outtable.intensPerPix = outtable.intensPerPix - baselineVal;
end
    
%%%% plotting
if any(strcmp(outtable.Properties.VariableNames,'sec'))
    sectionthickness = 40; % microns
    secloc = sectionthickness * outtable.sec;  %%%%% - sectionthickness/2;
    plot(secloc,outtable.intensPerPix)
    xlabel('Depth (microns)')
    ylabel('Projection Intensity Per Pixel')
%     set(gca,'ylim',[0 max(get(gca,'ylim'))])
end



