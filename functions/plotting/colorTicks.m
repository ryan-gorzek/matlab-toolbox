
function plotLabels = colorTicks(tickLabels,tickColors,NameValueArgs)
% colorTicks Display or return colored tick labels.
%
% Author: Ryan Gorzek
%
% Input Arguments:
%
%   tickLabels -- cell array of strings that specify tick labels.
%
%   tickColors -- cell array of RGB vectors that specify tick label colors.
%
%     Name-Value Arguments (default):
%
%       task (display) -- string ('display' or 'return') that specifies whether to display tick labels or return cell array of 
%         strings containing tick labels with concatenated LaTeX color codes. Specifying 'display' also returns ticks labels 
%         with LaTeX color codes.
%
%       axis (x) -- string or cell array of strings ('x', 'y', and/or 'z') that specify the axis or axes on which to display 
%         colored tick labels.
%

arguments
    
    tickLabels (1,:) {mustBeA(tickLabels,'cell'),mustBeText}
    tickColors (1,:) {mustBeA(tickColors,'cell')}
    NameValueArgs.task {mustBeMember(NameValueArgs.task,{'display','return'})} = 'display'
    NameValueArgs.axis {mustBeMember(NameValueArgs.axis,{'x','y','z'})} = 'x'
    
end

    if strcmp(NameValueArgs.task,'display') && ~isempty(findall(0,'Type','Figure')), ax = gca; end
    
    colorStrings = cell(1,numel(tickColors));
    
    for col = 1:numel(tickColors)
        
        tickCol = sprintf('olor[rgb]{%.3d %.3d %.3d}',tickColors{col}(1),tickColors{col}(2),tickColors{col}(3));
        colorStrings{col} = strcat('\c',tickCol);
        
    end

    plotLabels = strcat(colorStrings,tickLabels);
    
    for axisNum = 1:numel(NameValueArgs.axis)
        
        if iscell(NameValueArgs.axis), currAxis = NameValueArgs.axis{axisNum}; else, currAxis = NameValueArgs.axis(axisNum); end

        if strcmp(NameValueArgs.task,'display') && ~isempty(findall(0,'Type','Figure')) && isa(ax,'matlab.graphics.chart.HeatmapChart')

           switch currAxis
                case 'x', ax.XDisplayLabels = plotLabels; 
                case 'y', ax.YDisplayLabels = plotLabels;
                case 'z', error('No Z-axis in a heatmap chart.');
            end

        elseif strcmp(NameValueArgs.task,'display') && ~isempty(findall(0,'Type','Figure')) && ~isa(ax,'matlab.graphics.chart.HeatmapChart')

            switch currAxis
                case 'x', ax.XTickLabel = plotLabels;
                case 'y', ax.YTickLabel = plotLabels;
                case 'z', ax.ZTickLabel = plotLabels;
            end

        end
    
    end

end

