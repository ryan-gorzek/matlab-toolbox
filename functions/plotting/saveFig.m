
function saveFig(figPath,NameValueArgs)

arguments
    
    figPath string
    NameValueArgs.imType = 'png'
    NameValueArgs.saveFigure = true
    NameValueArgs.paramsIn = []
    NameValueArgs.saveScript = true
    NameValueArgs.figure = []

end

if NameValueArgs.saveFigure == true 

    outf = getframe(gcf);
    imwrite(outf.cdata,strcat(figPath,'_',date,'.',NameValueArgs.imType),NameValueArgs.imType) % save current figure
    
end

figStruct.figName = figPath;
figStruct.dateTime = datetime;
figStruct.matlabVersion = version;
figStruct.figImage = getframe(gcf);

if NameValueArgs.saveFigure == true
    f = get(gcf);
    figStruct.matlabFig = f;
end

figStruct.params = NameValueArgs.paramsIn;

if NameValueArgs.saveScript == true
    
    dependStruct = getDependencyStruct(omitStack = 2);
    
    figStruct.script = dependStruct.script;
    
    if isfield(dependStruct,'dependencies')
        figStruct.dependencies = dependStruct.dependencies;
    end
    
end

%%%% order fieldnames
fieldOrder = {'figName','dateTime','script','dependencies','params','matlabFig','figImage','matlabVersion'};

[~,fieldIdx] = ismember(fieldnames(figStruct),fieldOrder);
[~,fieldSort] = sort(fieldIdx(fieldIdx > 0),'ascend');
figStruct = orderfields(figStruct,fieldSort);

%%%% save figure structure
[filePath,fileName] = fileparts(figPath);

if ispc == true
    save(strcat(filePath,'\',fileName,'_figStruct_',date),'figStruct');
else
    save(strcat(filePath,'/',fileName,'_figStruct_',date),'figStruct');
end

end
