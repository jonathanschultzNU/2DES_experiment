function savearray_v2(data,filename,path)

addpath(path)

overwriteFile = true; % Default to overwriting or creating new file.
if exist(filename,'file')
  % Ask user if they want to overwrite the file.
  promptMessage = sprintf('This file already exists:\n%s\nDo you want to overwrite it?', filename);
  titleBarCaption = 'Overwrite?';
  buttonText = questdlg(promptMessage, titleBarCaption, 'Yes', 'No', 'Yes');
  if strcmpi(buttonText, 'No')
    % User does not want to overwrite. 
    % Set flag to not do the write.
    overwriteFile = false;
  end
end
if overwriteFile
  % File does not exist yet, or the user wants to overwrite an existing file.
  datsave = fullfile(path,filename); 
  save(datsave, 'data','-ascii')
  disp(filename)
end

end