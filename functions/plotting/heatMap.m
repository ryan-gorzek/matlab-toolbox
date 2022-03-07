
function heatmapObject = heatMap(inputData,NameValueArgs)
% heatMap Plot heatmap from vector or matrix input.
%
% Author: Ryan Gorzek
%
% Dependencies: none
%
% Input Arugments:
%
%   inputData -- vector or matrix of data for heatmap.
%
%   Name-Value Arguments (default):
%
%     title (none) -- string that specifies title.
%
%     xlabel (none) -- string that specifies x-axis label.
%
%     xticklabels ([1:nColumns]) -- vector of doubles or cell array of string that specify x-axis tick labels.
%
%     xtickangle (default) -- scalar that specifies x-axis tick label angle.
%
%     ylabel (none) -- string that specifies y-axis label.
%
%     yticklabels ([1:nColumns]) -- vector of doubles or cell array of string that specify y-axis tick labels.
%
%     ytickangle (default) -- scalar that specifies y-axis tick label angle.
%
%     fontSize (12) -- scalar that specifies font size.
%
%     cellLabelFormat (default) -- string that specifies cell label format (e.g., %.2f).
%
%     cellLabelColor (default) -- RGB vector that specifies cell label color.
%
%     colormap (default) -- MATLAB colormap name or matrix of RGB vectors that specify colormap.
%
%     colorLimits (default) -- vector that specifies color limits.
%
%     colorbar ('on') -- string that specifies whether to display colorbar. Options are 'on' or 'off'.
%
%     nanColor ([0.5,0.5,0.5]) -- RGB vector that specifies missing data color.
%
%     sparse (false) -- logical that specifies whether to plot a sparse heatmap. If sparse = true, inputData values of 
%       zero are set to nan and missing data color is set to the lowest RGB value in the colormap.
%
%     grid ('on') -- string that specifies whether to display gridlines. Options are 'on' or 'off'.
%
% Output Arguments:
%
%   heatmapObject -- heatmap object. See MATLAB heatmap documentation for more information.
%

arguments
    
    inputData double
    NameValueArgs.title (1,1) string = []
    NameValueArgs.xlabel (1,1) string = []
    NameValueArgs.xticklabels (1,:) = 1:size(inputData,2)
    NameValueArgs.xtickangle (1,1) double = []
    NameValueArgs.ylabel (1,1) string = []
    NameValueArgs.yticklabels (1,:) = 1:size(inputData,1)
    NameValueArgs.ytickangle (1,1) double = []
    NameValueArgs.fontSize (1,1) double = 12
    NameValueArgs.cellLabelFormat (1,1) string = []
    NameValueArgs.cellLabelColor (1,3) double = []
    NameValueArgs.colormap (:,3) double = []
    NameValueArgs.colorLimits (1,2) double = []
    NameValueArgs.colorbar {mustBeMember(NameValueArgs.colorbar,{'on','off'})} = 'on'
    NameValueArgs.nanColor (1,3) double = [0.5,0.5,0.5]
    NameValueArgs.sparse logical = false
    NameValueArgs.grid {mustBeMember(NameValueArgs.grid,{'on','off'})} = 'on'

end

%%%% change zeros to nan if sparse = true

if NameValueArgs.sparse == true, inputData(inputData == 0) = nan; end

%%%% plot heatmap

heatmapObject = heatmap(inputData);

%%%% set title, axis labels, tick labels, tick label angles, font size, cell label format, and cell label color

if ~isempty(NameValueArgs.title), heatmapObject.Title = NameValueArgs.title; end % heatmap title

if ~isempty(NameValueArgs.xlabel), heatmapObject.XLabel = NameValueArgs.xlabel; end % x-axis label

heatmapObject.XDisplayLabels = NameValueArgs.xticklabels; % x-axis tick labels

if ~isempty(NameValueArgs.xtickangle) % x-axis tick label angle
    warning('off','MATLAB:structOnObject');
    heatmapStruct = struct(heatmapObject); heatmapStruct.NodeChildren(3).XTickLabelRotation = NameValueArgs.xtickangle;
end

if ~isempty(NameValueArgs.ylabel), heatmapObject.YLabel = NameValueArgs.ylabel; end % y-axis label

heatmapObject.YDisplayLabels = NameValueArgs.yticklabels; % y-axis tick labels

if ~isempty(NameValueArgs.ytickangle) % y-axis tick label angle
    warning('off','MATLAB:structOnObject');
    heatmapStruct = struct(heatmapObject); heatmapStruct.NodeChildren(3).YTickLabelRotation = NameValueArgs.ytickangle;
end

heatmapObject.FontSize = NameValueArgs.fontSize; % font size

if ~isempty(NameValueArgs.cellLabelFormat), heatmapObject.CellLabelFormat = NameValueArgs.cellLabelFormat; end % cell label format

if ~isempty(NameValueArgs.cellLabelColor), heatmapObject.CellLabelColor = NameValueArgs.cellLabelColor; end % cell label color

%%%% set colormap, color limits, colorbar visibility, and nan color

if ~isempty(NameValueArgs.colormap), heatmapObject.Colormap = NameValueArgs.colormap; end % colormap

if ~isempty(NameValueArgs.colorLimits), heatmapObject.ColorLimits = NameValueArgs.colorLimits; end % color limits

heatmapObject.ColorbarVisible = NameValueArgs.colorbar; % colorbar visibility

if ~isempty(NameValueArgs.nanColor), heatmapObject.MissingDataColor = NameValueArgs.nanColor; end % nan color

if NameValueArgs.sparse == true, heatmapObject.MissingDataColor = h.Colormap(1,:); end % set nan color to lowest colormap color for sparse = true

%%%% set grid visiblity

heatmapObject.GridVisible = NameValueArgs.grid;

%%%% set figure color to white

set(gcf,'color','w');

end
