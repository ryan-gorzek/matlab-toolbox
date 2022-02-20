
function setStyle(varargin)

    titlePos = find(strcmp(varargin,'t'));
    if isempty(titlePos)
        titlePos = find(strcmp(varargin,'title'));
    end
    xlabPos = find(strcmp(varargin,'x'));
    if isempty(xlabPos)
        xlabPos = find(strcmp(varargin,'xlabel'));
    end
    if isempty(xlabPos)
        xlabPos = find(strcmp(varargin,'xlab'));
    end
    ylabPos = find(strcmp(varargin,'y'));
    if isempty(ylabPos)
        ylabPos = find(strcmp(varargin,'ylabel'));
    end
    if isempty(ylabPos)
        ylabPos = find(strcmp(varargin,'ylab'));
    end

    if ~isempty(titlePos)
        title(varargin{titlePos+1},'Interpreter','none');
    end
    
    if ~isempty(xlabPos)
        xlabel(varargin{xlabPos+1});
    end
    
    if ~isempty(ylabPos)
        ylabel(varargin{ylabPos+1});
    end

if sum(strcmp(varargin,'heatmap')) == 1
    
    set(gca,'FontSize',13);
    set(gcf,'color','w');
    
else
    
    set(gca,'FontSize',13);
    set(gca, 'XColor', 'k', 'YColor', 'k');
    set(gca, 'TickDir', 'out', 'TickLength', [0.01, 0.01]);
    set(gca,'box','off');
    set(gcf,'color','w');
    set(gca,'LineWidth',1);
    
end

end
