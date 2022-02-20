
function [ax] = boundedLine(inputLine,NameValueArgs)

arguments
    
    inputLine (:,2) double
    NameValueArgs.lineBounds double = []
    NameValueArgs.lineColor = [0.2,0.2,1]
    NameValueArgs.boundFaceColor = []
    NameValueArgs.boundEdgeColor = []
    NameValueArgs.allPoints = false
    NameValueArgs.lineWidth = 2
    NameValueArgs.boundAlpha = 0.2
    NameValueArgs.lineStyle = '-'
    NameValueArgs.pointEdgeColor = []
    NameValueArgs.pointFaceColor = []
    NameValueArgs.pointFilled = true
    NameValueArgs.pointStyle = 'o'
    NameValueArgs.pointSize = 12
    NameValueArgs.pointIdx = []

end

hold on;

if isempty(NameValueArgs.boundFaceColor)
    NameValueArgs.boundFaceColor = NameValueArgs.lineColor;
end

if isempty(NameValueArgs.boundEdgeColor)
    NameValueArgs.boundEdgeColor = 'none';
end

if isempty(NameValueArgs.pointEdgeColor) && (~isempty(NameValueArgs.pointIdx) || NameValueArgs.allPoints == true)
    NameValueArgs.pointEdgeColor = NameValueArgs.lineColor;
end

if isempty(NameValueArgs.pointFaceColor) && (~isempty(NameValueArgs.pointIdx) || NameValueArgs.allPoints == true)
    NameValueArgs.pointFaceColor = NameValueArgs.lineColor;
end

if ~isempty(NameValueArgs.lineBounds) && size(NameValueArgs.lineBounds,2) > 1

    lowerPatchIdx = [inputLine(:,1),inputLine(:,2) - NameValueArgs.lineBounds(:,1)];
    upperPatchIdx = [inputLine(:,1),inputLine(:,2) + NameValueArgs.lineBounds(:,2),inputLine(:,1)];
    lineIdx = inputLine;
    
    plotLower = vertcat(lowerPatchIdx,flip(lineIdx));
    plotUpper = vertcat(upperPatchIdx,flip(lineIdx));
    
    patch('XData',plotLower(:,1),'YData',plotLower(:,2),'EdgeColor',NameValueArgs.boundEdgeColor,'FaceColor',NameValueArgs.boundFaceColor,'FaceAlpha',NameValueArgs.boundAlpha)
    hold on;
    patch('XData',plotUpper(:,1),'YData',plotUpper(:,2),'EdgeColor',NameValueArgs.boundEdgeColor,'FaceColor',NameValueArgs.boundFaceColor,'FaceAlpha',NameValueArgs.boundAlpha)
   
elseif ~isempty(NameValueArgs.lineBounds) && size(NameValueArgs.lineBounds,2) == 1
    
    lowerPatchIdx = [inputLine(:,1),inputLine(:,2) - NameValueArgs.lineBounds(:,1)];
    upperPatchIdx = [inputLine(:,1),inputLine(:,2) + NameValueArgs.lineBounds(:,1)];
    lineIdx = inputLine;
    
    plotLower = vertcat(lowerPatchIdx,flip(lineIdx));
    plotUpper = vertcat(upperPatchIdx,flip(lineIdx));
    
    patch('XData',plotLower(:,1),'YData',plotLower(:,2),'EdgeColor',NameValueArgs.boundEdgeColor,'FaceColor',NameValueArgs.boundFaceColor,'FaceAlpha',NameValueArgs.boundAlpha)
    hold on;
    patch('XData',plotUpper(:,1),'YData',plotUpper(:,2),'EdgeColor',NameValueArgs.boundEdgeColor,'FaceColor',NameValueArgs.boundFaceColor,'FaceAlpha',NameValueArgs.boundAlpha)
    
end

if isempty(NameValueArgs.pointIdx) && NameValueArgs.allPoints == false

    plot(inputLine(:,1),inputLine(:,2),'Color',NameValueArgs.lineColor,'LineStyle',NameValueArgs.lineStyle,'LineWidth',NameValueArgs.lineWidth);
    
elseif isempty(NameValueArgs.pointIdx) && NameValueArgs.allPoints == true

    plot(inputLine(:,1),inputLine(:,2),'Color',NameValueArgs.lineColor,'LineStyle',NameValueArgs.lineStyle,'LineWidth',NameValueArgs.lineWidth);
    hold on;
    if NameValueArgs.pointFilled == true
        scatter(inputLine(:,1),inputLine(:,2),NameValueArgs.pointSize,NameValueArgs.pointStyle,'filled','MarkerEdgeColor',NameValueArgs.pointEdgeColor,'MarkerFaceColor',NameValueArgs.pointFaceColor);
    else
        scatter(inputLine(:,1),inputLine(:,2),NameValueArgs.pointSize,NameValueArgs.pointStyle,'MarkerEdgeColor',NameValueArgs.pointEdgeColor,'MarkerFaceColor',NameValueArgs.pointFaceColor);
    end

elseif ~isempty(NameValueArgs.pointIdx)
    
    plot(inputLine(:,1),inputLine(:,2),'Color',NameValueArgs.lineColor,'LineStyle',NameValueArgs.lineStyle,'LineWidth',NameValueArgs.lineWidth);
    hold on;
    if NameValueArgs.pointFilled == true
        scatter(inputLine(NameValueArgs.pointIdx,1),inputLine(NameValueArgs.pointIdx,2),NameValueArgs.pointSize,NameValueArgs.pointStyle,'filled','MarkerEdgeColor',NameValueArgs.pointEdgeColor,'MarkerFaceColor',NameValueArgs.pointFaceColor);
    else
        scatter(inputLine(NameValueArgs.pointIdx,1),inputLine(NameValueArgs.pointIdx,2),NameValueArgs.pointSize,NameValueArgs.pointStyle,'MarkerEdgeColor',NameValueArgs.pointEdgeColor,'MarkerFaceColor',NameValueArgs.pointFaceColor);
    end
    
end

set(gca,'FontSize',13);
set(gca, 'XColor', 'k', 'YColor', 'k');
set(gca, 'TickDir', 'out', 'TickLength', [0.01, 0.01]);
set(gca,'box','off');
set(gcf,'color','w');
set(gca,'LineWidth',1);
ax = get(gca);
    
end
