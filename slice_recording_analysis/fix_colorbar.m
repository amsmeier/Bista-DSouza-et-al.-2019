function [  ] = fix_colorbar
%FIX_COLORBAR Reset the colorbar created by RDsCRACM_AM.m to its original Y ticks. 
%%% last edited by AM 8/11/15
global group_images_scalebar_labels cbar % globals created by RDsCRACM.m

for i = 1:numel(cbar)
    set(cbar(i),'YTick',linspace(0,64,length(group_images_scalebar_labels)))
end

