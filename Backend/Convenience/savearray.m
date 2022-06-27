function savearray(scans,struct,filename,field,varsave)

overwriteFile = true; % Default to overwriting or creating new file.
if exist([num2str(scans) filename],'file')
  % Ask user if they want to overwrite the file.
  promptMessage = sprintf('This file already exists:\n%s\nDo you want to overwrite it?', [num2str(scans) filename]);
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
  datsave = fullfile(struct{1,1}.workuppath,[num2str(scans) filename]); 
%   delete(datsave);
  varsave = struct{1,field}.(varsave);
  save(datsave, 'varsave','-ascii')
  disp(filename)
end

end