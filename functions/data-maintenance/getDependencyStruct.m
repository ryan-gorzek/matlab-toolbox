
function [userCode,matlabInfo] = getDependencyStruct(NameValueArgs)
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

arguments
    
    NameValueArgs.omitStack = 1
    
end

%%%% get function stack, omitting this function

[ST] = dbstack('-completenames',NameValueArgs.omitStack); 

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
