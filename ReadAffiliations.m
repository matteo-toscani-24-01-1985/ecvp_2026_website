clear all
close all

txt = fileread('talks.js');

% Remove JavaScript wrapper
txt = erase(txt, "const talks=");
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

% Display results
for i = 1:length(talks)
    fprintf('%s - %s - %s\n', ...
        talks(i).Day, ...
        talks(i).Time, ...
        talks(i).Speaker);
end

affiliations=readtable('Final_Main_Affiliates.xlsx');

% for each talk, get authors and affilitations
for i = 1:length(talks)
    id=talks(i).SubmissionID;

end