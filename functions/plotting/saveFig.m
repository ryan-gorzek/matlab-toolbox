
function figStruct = saveFig(figPath,NameValueArgs)
% saveFig Save figure and MATLAB structure containing code and dependencies used to produce figure.
%
% Author: Ryan Gorzek
%
% Dependencies -- getDependencyStruct (nested)
%
% Input Arguments:
%
%   figPath -- string that specifies the desired file path for writing the current figure.
%
%   Name-Value Arguments: (default)
%
%     imType ('png') -- string that specifies the desired image file type for writing the current figure. See MATLAB imwrite 
%       documentation for more information.
%
%     saveParams ([]) -- wildcard field for saving parameters used to generate current figure.
%
% Output Arguments:
%
%   figStruct -- data structure containing figure image, path, MATLAB structure, date/time, MATLAB version, 
%     dependency structure (see getDependencyStruct function), and optional parameters structure
%

arguments
    
    figPath (1,1) string
    NameValueArgs.imType (1,1) string = 'png'
    NameValueArgs.saveParams = []

end

%%%% get and save current figure

outf = getframe(gcf);
imwrite(outf.cdata,strcat(figPath,'_',date,'.',NameValueArgs.imType),NameValueArgs.imType);

%%%% save figure data to structure

figStruct.figImage = getframe(gcf); % snapshot of figure
f = get(gcf); figStruct.figObject = f; % MATLAB figure structure

figStruct.figName = figPath; % figure path
figStruct.dateTime = datetime; % date and time of save
figStruct.matlabVersion = version; % MATLAB version number

figStruct.params = NameValueArgs.saveParams; % optional parameters used to generate figures

dependStruct = getDependencyStruct(); % get dependency structure
figStruct.script = dependStruct.script; % save script used to generate figure
if isfield(dependStruct,'dependencies'), figStruct.dependencies = dependStruct.dependencies; end % save dependencies used to generate figure

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

%%%% dependencies

% getDependencyStruct

function [userCode,matlabInfo] = getDependencyStruct()
% getDependencyStruct Get data structure containing snapshots of current script and custom dependencies.
%
% Author: Ryan Gorzek
%
% Dependencies: none
%
% Input Arguments:
%
%   Name-value Arguments (default):
%
%     omitStack (1) -- number of nested functions within function call stack to omit from dependency structure.
%
% Output Arguments:
%
%   userCode -- data structure containing paths and txt files of current script and custom dependencies.
%
%   matlabInfo -- data structure containing list of MathWorks dependencies of current script. See MATLAB 
%     matlab.codetools.requiredFilesAndProducts documentation for more information.
%

%%%% get function stack, omitting this function

[ST] = dbstack('-completenames',2); % omit this function and saveFig

scriptName = ST.file; % get full path of current script

userCode.script.fullPath = scriptName; % save full path of current script
userCode.script.codeTxt = fileread(scriptName); % get txt file version of current script

%%%% get dependencies and list of  of current script

[userList,matlabInfo] = matlab.codetools.requiredFilesAndProducts(scriptName); 

dependNames = setdiff(userList,scriptName);

for dep = 1:numel(dependNames)
    
    depName = dependNames{dep}; % get dependency

    userCode.dependencies{dep}.fullPath = depName; % save full path of dependency of current script
    userCode.dependencies{dep}.codeTxt = fileread(depName); % get txt file version of dependency of current script
    
end

end

end
