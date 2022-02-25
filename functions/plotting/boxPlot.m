
function [xCoordinates,lgdObject,handleObject] = boxPlot(inputData,NameValueArgs)
% boxPlot Plot boxplot from vector or matrix input.
%
% Author: Ryan Gorzek
% 
% Input Arguments:
%
%   inputData -- vector or matrix of data for boxplot. If inputData is a vector, specify
%   categorical name-value argument inputLabels to plot multiple boxes. If inputData is
%   a matrix, each box represents a column.
%
%   Name-Value Arguments (default):
%
%     inputLabels ([]) -- vector of categorical labels for vector input.
%
%     groupSize (1) -- scalar that specifies the number of boxes by which to group the data (if grouping).
%
%     labelGroup (false) -- logical that specifies whether to shrink the number of x-axis labels to one per group (if grouping).
%
%     boxLabels ([1:nBoxes]) -- cell array of strings that specify x-axis labels.
%
%     boxColors ([0.7,0.7,0.7]) -- cell array of RGB vectors that specify box colors.
%
%     pointSize (30) -- scalar that specifies the size of outlier points.
%
%     axFontSize (13) -- scalar that specifies the axes font size.
%
%     lgdLabels (none) -- cell array of strings that specify legend labels.
%
%     lgdColors (none) -- cell array of RBG vectors that specify legend colors.
%
%     lgdLocation ('northeast') -- string that specifies legend location. See MATLAB legend documentation for options.
%
%     lgdPosition (default) -- vector that specifies legend position.
%
%     lgdBox ('off') -- string that specifies whether to show legend box. Options are 'on' or 'off'.
%
%     lgdFontSize (12) -- scalar that specifies legend font size.
%
%     lgdLineWidth (8) -- scalar that specifies the width of legend markers.
%
% Output Arguments:
%
%   xCoors -- vector of x-axis coordinates corresponding to each plotted box.
%
%   lgdObject -- legend object. See MATLAB legend documentation for more information.
%
%   handleObject -- legend handle object, i.e. a graphics array of legend lines and text.
%

arguments
    
    inputData double
    NameValueArgs.inputLabels (:,1) double = []
    NameValueArgs.groupSize (1,1) {mustBeNumeric} = 1
    NameValueArgs.labelGroup = false
    NameValueArgs.boxLabels (1,:) {mustBeA(NameValueArgs.boxLabels,'cell'),mustBeText} = {}
    NameValueArgs.boxColors (1,:) {mustBeA(NameValueArgs.boxColors,'cell')} = {}
    NameValueArgs.pointSize (1,1) double = 30
    NameValueArgs.axFontSize (1,1) double = 13
    NameValueArgs.lgdLabels (1,:) {mustBeA(NameValueArgs.lgdLabels,'cell'),mustBeText} = {}
    NameValueArgs.lgdColors (1,:) {mustBeA(NameValueArgs.lgdColors,'cell')} = {}
    NameValueArgs.lgdLocation (1,1) string = 'northeast'
    NameValueArgs.lgdPosition (1,4) double = []
    NameValueArgs.lgdBox (1,1) string = 'off'
    NameValueArgs.lgdFontSize (1,1) double = 12
    NameValueArgs.lgdLineWidth (1,1) double = 8

end

%%%% assign temporary variables for name-value arguments

inputLabels = NameValueArgs.inputLabels;
groupSize = NameValueArgs.groupSize;
labelGroup = NameValueArgs.labelGroup;
boxLabels = NameValueArgs.boxLabels;
boxColors = NameValueArgs.boxColors;
pointSize = NameValueArgs.pointSize;
axFontSize = NameValueArgs.axFontSize;
lgdLabels = NameValueArgs.lgdLabels;
lgdColors = NameValueArgs.lgdColors;
lgdLocation = NameValueArgs.lgdLocation;
lgdPosition = NameValueArgs.lgdPosition;
lgdBox = NameValueArgs.lgdBox;
lgdFontSize = NameValueArgs.lgdFontSize;
lgdLineWidth = NameValueArgs.lgdLineWidth;

%%%% check for vector or matrix input data

if isempty(inputLabels) % if no inputLabels specified, reshape matrix input into vector and produce labels
    
    inputLabels = repmat(1:size(inputData,2),[size(inputData,1),1]); % create labels for inputData matrix
    
    inputLabels = reshape(inputLabels,[],1); % reshape inputLabels into a column vector
    inputData = reshape(inputData,[],1);    % reshape inputData into a column vector
    
elseif ~isempty(inputLabels) && size(inputData,2) ~= 1 % if inputLabels are specified but inputData is not in column vector, reshape
    
    inputData = reshape(inputData,[],1);

end

%%%% set default box labels (numbered) and box colors (gray) if not specified

if isempty(boxLabels), boxLabels = cellstr(string(1:numel(unique(inputLabels)))); end
if isempty(boxColors), boxColors = repmat({[0.7,0.7,0.7]},[1,numel(unique(inputLabels))]); end

%%%% calculate the number of boxes and groups

nBoxes = numel(unique(inputLabels)); % get number of boxes to plot based on inputLabels
nGroups = nBoxes/groupSize; % get number of box groups based on nCats and groupSize

uniqueLabels = sort(unique(inputLabels),'ascend')'; % get unique labels from inputLabels

%%%% throw error if nGroups is not an integer

if rem(nGroups,1) ~= 0, error('Number of input categories is not divisible by number of groups.'); end

%%%% check boxLabels against nGroups to warn user about specifying labelGroup

if labelGroup == true && numel(boxLabels) > nGroups
    error('Too many boxLabels for number of groups, did you mean to specify labelGroup = true?');
elseif labelGroup == true && numel(boxLabels) < nGroups
    error('Too few boxLabels for number of groups, did you mean to specify labelGroup = true?');
end

%%%% check whether labels match nGroups if labelGroup = false

if groupSize ~= 1 && ...
   numel(boxLabels) == nGroups && ...
   numel(boxColors) == groupSize && ...
   labelGroup == false
    
    error('Insufficient number of boxLabels, did you mean to specify labelGroup = true?');

end

%%%% get x-coordinates for plotting

if nGroups == 1
    
    xCoordinates = [0.70:0.65:0.7+(0.65*nCats)-0.65];
   
else

    xCoordinates = [0.70:0.55:0.70+(0.55*(nBoxes/nGroups)-0.55)]; initCoors = [0.70:0.55:0.70+(0.55*(nBoxes/nGroups)-0.55)];

    for grp = 2:nGroups, xCoordinates = horzcat(xCoordinates,initCoors+(xCoordinates(end)+0.4)); end

end

%%%% intialize matrices for storing max/min to set axes

maxMat = zeros(nBoxes,3); % uQuar, uWhisk, outliersU
minMat = zeros(nBoxes,3); % lQuar, lWhisk, outliersL

%%%% plot

for cat = uniqueLabels

    catNum = find(uniqueLabels == cat);
    
    clear lQuar uQuar med lWhisk uWhisk outliersU outliersL

    %%%% get data for current box
    
    currData = inputData(inputLabels == cat,1);
    
    %%%% plot box if there are at least 4 data points
    
    if nnz(~isnan(currData)) > 4
        
        % get median of categories
        med = median(currData,1,'omitnan');
        % get 75 percentile of categories
        uQuar = prctile(currData,75,1);
        % get 25 percentile of categories
        lQuar = prctile(currData,25,1);
        % get 97.5 percentile of categories
        maxWhisk = uQuar + 1.5*(uQuar-lQuar);
        uWhisk = max(currData(currData < maxWhisk & currData >= uQuar));
        if isempty(uWhisk), uWhisk = maxWhisk; end
        % get 2.5 percentile of categories
        minWhisk = lQuar - 1.5*(uQuar-lQuar);
        lWhisk = min(currData(currData > minWhisk & currData <= lQuar));
        if isempty(lWhisk), lWhisk = minWhisk; end
        
        hold on;

        % plot box with bounds at quartiles
        rectangle('Position',[xCoordinates(catNum)-0.25 lQuar 0.5 (uQuar-lQuar)],'FaceColor',boxColors{catNum},'EdgeColor','k','LineWidth',1,'Tag','box');
        % plot left half median line
        line([xCoordinates(catNum)-0.25 xCoordinates(catNum)],[med med],'Color','k','LineWidth',2);
        % plot right half median line
        line([xCoordinates(catNum) xCoordinates(catNum)+0.25],[med med],'Color','k','LineWidth',2);
        % plot lower whisker
        line([xCoordinates(catNum) xCoordinates(catNum)],[lQuar lWhisk],'Color','k','LineWidth',0.75);
        % plot upper whisker
        line([xCoordinates(catNum) xCoordinates(catNum)],[uQuar uWhisk],'Color','k','LineWidth',0.75,'Tag','uwhisk');
        % plot lower whisker bar
        line([xCoordinates(catNum)-0.1 xCoordinates(catNum)+0.1],[lWhisk lWhisk],'Color','k','LineWidth',0.5);
        % plot upper whisker bar
        line([xCoordinates(catNum)-0.1 xCoordinates(catNum)+0.1],[uWhisk uWhisk],'Color','k','LineWidth',0.5);

        %%%% plot outliers
        
        % upper
        if any(currData > uWhisk)
            
            scatter(xCoordinates(catNum),currData(currData > uWhisk),pointSize,'filled','MarkerFaceColor',boxColors{catNum},'MarkerEdgeColor',boxColors{catNum});
            outliersU = currData(currData > uWhisk);
            
        else
            
            outliersU = nan;
            
        end
        
        % lower
        if any(currData < lWhisk)
            
            scatter(xCoordinates(catNum),currData(currData < lWhisk),pointSize,'filled','MarkerFaceColor',boxColors{catNum},'MarkerEdgeColor',boxColors{catNum});
            outliersL = currData(currData < lWhisk);
            
        else
            
            outliersL = nan;
            
        end

        %%%% store min/max from each category for setting axis limits
        maxMat(catNum,:) = [uQuar,uWhisk,max(outliersU)];
        minMat(catNum,:) = [lQuar,lWhisk,min(outliersL)];
        
    elseif nnz(~isnan(currData)) == 0
        
        %%%% store min/max from each category for setting limits
        maxMat(catNum,:) = [repmat(max(currData),[1,3])];
        minMat(catNum,:) = [repmat(min(currData),[1,3])];
    
    elseif nnz(~isnan(currData)) <= 4
    
        % get median of categories
        med = median(currData,1,'omitnan');
        
        hold on;

        % plot left half median line
        line([xCoordinates(catNum)-0.25 xCoordinates(catNum)],[med med],'Color','k','LineWidth',2)
        % plot right half median line
        line([xCoordinates(catNum) xCoordinates(catNum)+0.25],[med med],'Color','k','LineWidth',2)
        % scatter data points
        scatter(xCoordinates(catNum),currData,pointSize,'filled','MarkerFaceColor',boxColors{catNum},'MarkerEdgeColor',boxColors{catNum});

        %%%% store min/max from each category for setting axis limits
        maxMat(catNum,:) = [repmat(max(currData),[1,3])];
        minMat(catNum,:) = [repmat(min(currData),[1,3])];
        
    end
    
end

%%%% set x-axis limits

xlim([0.2 xCoordinates(end)+0.5]);

%%%% set x-axis tick labels

xLabPos = [];

if labelGroup == true

    for group = 1:(nCats/nGroups):nCats, xLabPos = horzcat(xLabPos,median(xCoordinates(group:group+(nCats/nGroups)-1))); end

    set(gca,'xtick',xLabPos); set(gca,'xticklabel',boxLabels);

else
        
    set(gca,'xtick',xCoordinates); set(gca,'xticklabel',boxLabels);

end

%%%% set axis appearance

set(gca,'FontSize',axFontSize);
set(gca, 'XColor','k','YColor','k');
set(gca, 'TickDir','out','TickLength', [0.01, 0.01]);
set(gca,'box','off');
set(gcf,'color','w');
set(gca,'LineWidth',1);
ax = get(gca);

%%%% set y-axis limits

if ~all(isnan(maxMat),'all')

    yUpper = max(maxMat,[],'all'); yLower = min(minMat,[],'all');
    
    yExt = (yUpper-yLower)*0.2;
    
    ylim([yLower-yExt yUpper+yExt]);

end

%%%% add legend if specified

if ~isempty(lgdLabels) && ~isempty(lgdColors)

    [lgdObject,handleObject,~,~] = legend(lgdLabels);
    
    h1 = findobj(handleObject,'Type','line'); set(h1,'LineWidth',lgdLineWidth);

    for col = 1:2:numel(lgdColors), set(h1(iter),'Color',lgdColors{col}); end

    if strcmp(lgdBox,'off'), legend boxoff; end

    lgdObject.Location = lgdLocation;
    if ~isempty(lgdPosition), lgdObject.Position = lgdPosition; end
    lgdObject.String = strcat('\fontsize{',num2str(lgdFontSize),'}',lgdObject.String);
    lgdObject.FontSize = lgdFontSize;
    
else
    
    lgdObject = []; handleObject = [];

end

end
