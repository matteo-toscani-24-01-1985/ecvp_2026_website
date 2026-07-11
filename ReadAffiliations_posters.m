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
    talks(i).Topic = getField(obj, 'Topic');
    
    talks(i).Title = getField(obj, 'Title');
    talks(i).Speaker = getField(obj, 'Author');
    talks(i).CoAuthors = getField(obj, 'CoAuthors');
    talks(i).Abstract = getField(obj, 'Abstract');

    % Numeric field
    talks(i).SubmissionID = str2double(getField(obj, 'SubmissionID'));

end
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
    % if i==17
    %     names_talks=[names_talks(1) {'Xiaoqian Yan'} names_talks(2:end)];
    % end
    
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

%if i==134;error pd;end
if i==134
    names=[names(1) {'Eole Lapeyre'} names(2:end)];
end
if i==241
  names_talks{5}='Merav Ahissar';
end
% if i==251
%     error pd
% end
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


delete('posters_tmp.txt')

fid = fopen('posters_tmp.txt','w','n','UTF-8');

fprintf(fid,'const posters=[');

for i = 1:numel(all_talks)

    t = all_talks(i);

    if i > 1
        fprintf(fid,',');
    end

    fprintf(fid,'{');

    fprintf(fid,'"Day": "%s", ', escapeJS(t.Day));
    fprintf(fid,'"Time": "%s", ', escapeJS(t.Time));
    fprintf(fid,'"SessionID": "%s", ', escapeJS(t.Session));
    fprintf(fid,'"Topic": "%s", ', escapeJS(t.Topic));
    fprintf(fid,'"Title": "%s", ', escapeJS(t.Title));

    % Keep Author
    fprintf(fid,'"Author": "%s", ', escapeJS(t.Speaker));

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