
function tickColors = colorTicks(labels,colors,NameValueArgs)

arguments
    
    labels (1,:) {mustBeA(labels,'cell')}
    colors (1,:) {mustBeA(colors,'cell')}
    NameValueArgs.task {mustBeMember(NameValueArgs.task,{'show','get'})} = 'show'
    NameValueArgs.axis {mustBeMember(NameValueArgs.axis,{'x','y','z'})} = 'x'
    
end
    ax = gca;
    
    tickColors = cell(1,numel(colors));
    for col = 1:numel(colors)
        
        tickCol = sprintf('olor[rgb]{%.3d %.3d %.3d}',colors{col}(1),colors{col}(2),colors{col}(3));
        tickColors{col} = ['\c',tickCol];
        
    end

    tickColors = strcat(tickColors,labels);

    if strcmp(NameValueArgs.task,'show') && isa(ax,'matlab.graphics.chart.HeatmapChart')

       switch NameValueArgs.axis
            case 'x'
                ax.XDisplayLabels{col} = [tickColors{col}];
            case 'y'
                ax.YDisplayLabels{col} = [tickColors{col}];
            case 'z'
                error('No Z-axis in a heatmap chart.')
        end

    elseif strcmp(NameValueArgs.task,'show')

        switch NameValueArgs.axis
            case 'x'
                ax.XTickLabel{col} = [tickColors{col}];
            case 'y'
                ax.YTickLabel{col} = [tickColors{col}];
            case 'z'
                ax.ZTickLabel{col} = [tickColors{col}];
        end

    end

end

