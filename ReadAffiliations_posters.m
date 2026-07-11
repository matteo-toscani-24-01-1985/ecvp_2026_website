clear all
close all
txt = fileread('posters_programme.html');

% Find the start of the line "const favs=new"

% Extract everything between <script> and "const favs=new"
tok = regexp(txt, '<script>\s*(.*?)\s*(?=const favs=new)', ...
    'tokens', 'once');
txt = tok{1};
% Remove JavaScript wrapper
txt = erase(txt, "const posters=");
txt = erase(txt, ";");

objects = regexp(txt, '\{(.*?)\}', 'tokens');

talks = struct([]);

for i = 1:length(objects)

    obj = objects{i}{1};

    % Extract fields
    talks(i).Day = getField(obj, 'Day');
    talks(i).Time = getField(obj, 'Time');
    talks(i).Session = getField(obj, 'Session');
    talks(i).Room = getField(obj, 'Room');
    talks(i).Title = getField(obj, 'Title');
    talks(i).Speaker = getField(obj, 'Speaker');
    talks(i).CoAuthors = getField(obj, 'CoAuthors');
    talks(i).Abstract = getField(obj, 'Abstract');

    % Numeric field
    talks(i).SubmissionID = str2double(getField(obj, 'SubmissionID'));

end
