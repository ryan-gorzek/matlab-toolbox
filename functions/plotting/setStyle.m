
function setStyle(NameValueArgs)
% setStyle Set figure style, labels, limits, and position.
%
% Author: Ryan Gorzek
%
% Dependencies: none
%
% Input Arguments:
%
%   Name-Value Arguments (default):
%
%     title (none) -- string that specifies plot title.
%
%     xlabel (none) -- string that specifies x-axis label.
%
%     xticks (automatic) -- vector that specifies x-axis tick marks.
%
%     xticklabels (automatic) -- cell array of strings that specify x-axis tick labels.
%
%     xtickangle (automatic) -- scalar that specifies x-axis tick label angle.
%
%     xlim (automatic) -- vector that specifies x-axis limits.
%
%     ylabel (none) -- string that specifies y-axis label.
%
%     yticks (automatic) -- vector that specifies y-axis tick marks.
%
%     yticklabels (automatic) -- cell array of strings that specify y-axis tick labels.
%
%     ytickangle (automatic) -- scalar that specifies y-axis tick label angle.
%
%     ylim (automatic) -- vector that specifies y-axis limits.
%
%     fontSize (13) -- scalar that specifies font size of axes text.
%
%     figPosition (automatic) -- vector that specifies figure position.
%

arguments
    
    NameValueArgs.title (1,1) string = ''
    NameValueArgs.xlabel (1,1) string = ''
    NameValueArgs.xticks (1,:) double = []
    NameValueArgs.xticklabels = []
    NameValueArgs.xtickangle (1,1) double = []
    NameValueArgs.xlim (1,2) double = []
    NameValueArgs.ylabel (1,1) string = ''
    NameValueArgs.yticks (1,:) double = []
    NameValueArgs.yticklabels = []
    NameValueArgs.ytickangle (1,1) double = []
    NameValueArgs.ylim (1,2) double = []
    NameValueArgs.fontSize (1,1) double = 13
    NameValueArgs.figPosition (1,4) double = []

end

if ~isempty(NameValueArgs.title), title(NameValueArgs.title); end
if ~isempty(NameValueArgs.xlabel), xlabel(NameValueArgs.xlabel); end
if ~isempty(NameValueArgs.xticks), xticks(NameValueArgs.xticks); end
if ~isempty(NameValueArgs.xticklabels), xticklabels(NameValueArgs.xticklabels); end
if ~isempty(NameValueArgs.xtickangle), xtickangle(NameValueArgs.xtickangle); end
if ~isempty(NameValueArgs.xlim), xlim(NameValueArgs.xlim); end
if ~isempty(NameValueArgs.ylabel), ylabel(NameValueArgs.ylabel); end
if ~isempty(NameValueArgs.yticks), yticks(NameValueArgs.yticks); end
if ~isempty(NameValueArgs.yticklabels), yticklabels(NameValueArgs.yticklabels); end
if ~isempty(NameValueArgs.ytickangle), ytickangle(NameValueArgs.ytickangle); end
if ~isempty(NameValueArgs.ylim), ylim(NameValueArgs.ylim); end

set(gca,'FontSize',NameValueArgs.fontSize);
set(gca,'XColor','k','YColor','k');
set(gca,'TickDir', 'out','TickLength',[0.01, 0.01]);
set(gca,'box','off');
set(gca,'LineWidth',1);

set(gcf,'color','w');

if ~isempty(NameValueArgs.figPosition), set(gcf,'Position',NameValueArgs.figPosition); end

end
