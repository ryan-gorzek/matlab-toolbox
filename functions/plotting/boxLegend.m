
function [l,hobj] = boxLegend(labels,colors,NameValueArgs)

arguments
    
    labels (1,:) {mustBeA(labels,'cell'),mustBeText}
    colors (1,:) {mustBeA(colors,'cell')}
    NameValueArgs.location (1,1) string = 'northeast'
    NameValueArgs.box (1,1) string = 'off'
    NameValueArgs.LineWidth (1,1) double = 8
    NameValueArgs.FontSize (1,1) double = 12
    
end

[l, hobj, ~,~] = legend(labels);
h1 = findobj(hobj,'Type','line');

set(h1,'LineWidth',NameValueArgs.LineWidth);

iter = 1;
for c = 1:numel(colors)
    set(h1(iter),'Color',colors{c});
    iter = iter + 2;
end

if strcmp(NameValueArgs.box,'off')
    legend boxoff
end

l.Location = NameValueArgs.location;
l.String = strcat('\fontsize{',num2str(NameValueArgs.FontSize),'}',l.String);
l.FontSize = NameValueArgs.FontSize;

end


