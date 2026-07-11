clear all
close all
txt = fileread('ECVP2026_TalksProgramme_FULL.html');

% Find the start of the line "const favs=new"

% Extract everything between <script> and "const favs=new"
tok = regexp(txt, '<script>\s*(.*?)\s*(?=const favs=new)', ...
    'tokens', 'once');
txt = tok{1};
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

% Correct IDs
talks(1).SubmissionID=520;
talks(4).SubmissionID=66;
talks(7).SubmissionID=202;
talks(10).SubmissionID=55;
talks(17).SubmissionID=132;
talks(20).SubmissionID=65;
talks(23).SubmissionID=617;
talks(26).SubmissionID=493;
talks(29).SubmissionID=362;
talks(35).SubmissionID=223;
talks(38).SubmissionID=298;
talks(41).SubmissionID=494;
talks(44).SubmissionID=221;
talks(47).SubmissionID=212;
talks(52).SubmissionID=15;
talks(55).SubmissionID=606;
talks(58).SubmissionID=514;
talks(61).SubmissionID=185;
talks(69).SubmissionID=428;
talks(72).SubmissionID=602;
talks(75).SubmissionID=354;
talks(78).SubmissionID=38;
talks(84).SubmissionID=282;
talks(87).SubmissionID=7;
talks(90).SubmissionID=19;
talks(93).SubmissionID=18;
talks(94).SubmissionID=455;
talks(100).SubmissionID=138;
talks(103).SubmissionID=227;
talks(106).SubmissionID=360;
talks(109).SubmissionID=111;
talks(112).SubmissionID=68;
talks(117).SubmissionID=187;
talks(120).SubmissionID=156;
talks(123).SubmissionID=125;
talks(126).SubmissionID=177;
talks(129).SubmissionID=577;
talks(146).SubmissionID=387;
talks(149).SubmissionID=506;
talks(152).SubmissionID=361;
talks(155).SubmissionID=327;
talks(158).SubmissionID=397;
talks(162).SubmissionID=74;
talks(163).SubmissionID=48;
talks(164).SubmissionID=110;
talks(165).SubmissionID=75;
talks(166).SubmissionID=379;
c=0;
for i = 1:length(talks)
    if talks(i).SubmissionID>=700
        fprintf('%s - %s - %s - %s\n', ...
            num2str(i), ...
            talks(i).Day, ...
            talks(i).Time, ...
            talks(i).Speaker);
        c=c+1;
    end
end
disp(c) % with no changes is 47.



affiliations=readtable('Final_Main_Affiliates.xlsx');

% make list of co-authros from both sources and compare

% for each talk, get authors and affilitations
all_talks=talks;


for i = 1:length(talks)
    id=talks(i).SubmissionID;
    posidIn_affiliations= find(affiliations.SubmissionId==id);
    coauth_talks=talks(i).CoAuthors;
    names_talks = cellstr(strtrim(split(coauth_talks, ',')));
    names_talks=names_talks';

    %%% CORRECTIONS
    if i==17
        names_talks=[names_talks(1) {'Xiaoqian Yan'} names_talks(2:end)];
    end
    % if i==20
    %     names_talks=[names_talks {'Marie L Smith'}];
    % 
    % end

    if i==152
        names_talks=[names_talks {'Tianwen Chen'}];
    end

    if i==166
        names_talks=[names_talks {'William Harwin'}    {'Alastair Barrow'}];
    end

    if i==17
        names_talks=names_talks([1 2 4 5 3 6]);
    end

    if isempty(names_talks{1})
        names_talks=names_talks(2:end);
    end
 if i==85
        names_talks=[names_talks([2 3 4 5 6]) ];
 end

 if i==126
     names_talks={'Omar Fahmi Jubran'};
 end
 if i==101
     names_talks=names_talks(2:end);
 end

  if i==132
     names_talks=names_talks(2:end);
 end
if i==161
     names_talks={'Joel Martin'};
 end
    c=0;
    clear names
    for au=2:12
        if au<3
            eval(['fn= affiliations.FirstName_' num2str(au) 'ndAuthor(posidIn_affiliations);']);
            eval(['sn= affiliations.LastName_' num2str(au) 'ndAuthor(posidIn_affiliations);']);
        elseif au<4
            eval(['fn= affiliations.FirstName_' num2str(au) 'rdAuthor(posidIn_affiliations);']);
            eval(['sn= affiliations.LastName_' num2str(au) 'rdAuthor(posidIn_affiliations);']);
        else
            eval(['fn= affiliations.FirstName_' num2str(au) 'thAuthor(posidIn_affiliations);']);
            eval(['sn= affiliations.LastName_' num2str(au) 'thAuthor(posidIn_affiliations);']);
        end
        if isempty(fn{1})==0
            c=c+1;
            names{c}=[fn{1} ' ' sn{1}];
        end

    end
if i==85
    names=names(1:(end-1));
    c=c-1;
end



    names_talks = regexprep(strtrim(names_talks), '^&\s*', '');

    new_names = {};

    for k = 1:numel(names_talks)
        if contains(names_talks{k}, '&')
            tmp = strtrim(split(names_talks{k}, '&'));
            new_names = [new_names; cellstr(tmp)];
        else
            new_names = [new_names; names_talks(k)];
        end
    end

    names_talks = new_names';


    for j=1:c
        if strcmp(names_talks{j},names{j}) ==0
            disp([names_talks{j} ' / ' names{j} ' id:' num2str(id) ' ind:' num2str(i)])
        end
    end

    speakers= [{talks(i).Speaker} names_talks];
    all_talks(i).Authors= speakers;
    c=0;
    clear affiliations_tmp
    for au=1:9
        eval(['af=affiliations.unique_Institute_' num2str(au)  '(posidIn_affiliations);']);
        eval(['co=affiliations.unique_Institute_country_' num2str(au) '(posidIn_affiliations);']);
        
  
        if iscell(af)==1 
            if isempty(af{1})==0
            c=c+1;
            affiliations_tmp{c}=[af{1} ' ' co{1}];
            end
        end
    end
 
    all_talks(i).Affiliations=affiliations_tmp;



% read all codes
c=0;
clear affiliation_codes
for au =1:10
    if au==1
        eval(['cde= affiliations.x1st_auth_codes(posidIn_affiliations);']);
    elseif au==2
        eval(['cde= affiliations.x2nd_auth_codes(posidIn_affiliations);']);
    elseif au==3
        eval(['cde= affiliations.x3rd_auth_codes(posidIn_affiliations);']);
    else
        eval(['cde= affiliations.x' num2str(au) 'th_auth_codes(posidIn_affiliations);']);
    end
if isempty(cde{1})==0
    c=c+1;
    cde = sscanf(cde{1}, '%f,').';
    affiliation_codes{au}=cde;
end
end
all_talks(i).Affiliation_codes=affiliation_codes;

% if i==20
%     error pd
% end
end


%  "Speaker": "John Smith",
%  "Authors": [
%     {"name":"John Smith","aff":[1]},
%     {"name":"Jane Brown","aff":[2]}
%  ],
%  "Affiliations":[
%     "University of Bournemouth, UK",
%     "University of Oxford, UK"
%  ]
% }

%{"Day": "Monday", "Time": "10:30", "Session": "Symposium: Strategies for searching: better understanding visual foraging through the study of individual differences", "Room": "Tregonwell Hall", "Title": "Foraging tempo revisited: How does time pressure contribute to individual differences in target selection behaviour?", "Speaker": "Ian M. Thornton", "CoAuthors": "Árni Kristjánsson", "Abstract": "An unexpected finding in the human foraging study by Kristjánsson, Jóhannesson & Thornton (2014) was that a minority of individuals (25%) showed little if any difference in run patterns under feature versus conjunction conditions. We termed these individuals "super-foragers". Since that time, similar cohorts have been reported in many other studies, and attempts have been made to understand the characteristics of such individuals. In the current presentation, we will briefly review what we know to-date about individual differences in the context of foraging, and will then focus on new studies from our group linking run-pattern preferences to more general cognitive mechanism, in particular "processing speed". Thornton, Nguyen & Kristjánsson (2021) demonstrated experimentally that manipulating the "foraging tempo" with which participants were allowed to select consecutive targets strongly influenced patterns of runs. Building on this finding, we will present new data exploring whether independently measured individual differences in the ability to make decisions under time pressure can be related to observed patterns of runs during human foraging tasks.", "SubmissionID": 701},
%%
delete('talks_tmp.txt')

fid = fopen('talks_tmp.txt','w','n','UTF-8');

fprintf(fid,'const talks=[');

for i = 1:numel(all_talks)

    t = all_talks(i);

    if i > 1
        fprintf(fid,',');
    end

    fprintf(fid,'{');

    fprintf(fid,'"Day": "%s", ', escapeJS(t.Day));
    fprintf(fid,'"Time": "%s", ', escapeJS(t.Time));
    fprintf(fid,'"Session": "%s", ', escapeJS(t.Session));
    fprintf(fid,'"Room": "%s", ', escapeJS(t.Room));
    fprintf(fid,'"Title": "%s", ', escapeJS(t.Title));

    % Keep Speaker
    fprintf(fid,'"Speaker": "%s", ', escapeJS(t.Speaker));

    % Keep CoAuthors
    fprintf(fid,'"CoAuthors": "%s", ', escapeJS(t.CoAuthors));

    % Add Authors structure
    fprintf(fid,'"Authors": [');

    for a = 1:numel(t.Authors)

        if a>1
            fprintf(fid,',');
        end

        fprintf(fid,'{"name":"%s","aff":[', ...
            escapeJS(t.Authors{a}));

        codes = t.Affiliation_codes{a};

        for c = 1:numel(codes)

            if c>1
                fprintf(fid,',');

            end

            fprintf(fid,'%d',codes(c));

        end

        fprintf(fid,']}');

    end

    fprintf(fid,'], ');


    % Add affiliations
    fprintf(fid,'"Affiliations": [');

    for a = 1:numel(t.Affiliations)

        if a>1
            fprintf(fid,',');

        end

        fprintf(fid,'"%s"', escapeJS(t.Affiliations{a}));

    end

    fprintf(fid,'], ');


    fprintf(fid,'"Abstract": "%s", ', escapeJS(t.Abstract));

    fprintf(fid,'"SubmissionID": %d', t.SubmissionID);

    fprintf(fid,'}');

end

fprintf(fid,'];');

fclose(fid);