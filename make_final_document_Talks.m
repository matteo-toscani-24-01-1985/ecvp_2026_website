%% Create Poster Booklet from JSON
% Input file: posters.json
% Format: const posters=[ {...}, {...} ];

clear; clc;close all


%% ---------------- READ JSON ----------------

jsonText = fileread('talks_tmp.txt');

% Remove JavaScript wrapper
jsonText = strtrim(jsonText);
jsonText = erase(jsonText,'const talks=');
jsonText = erase(jsonText,';');

% Decode
talks = jsondecode(jsonText);



%% ---------------- CREATE HTML ----------------

htmlFile = 'Talks_Booklet.html';
delete(htmlFile)
fid = fopen(htmlFile,'w','n','UTF-8');


%% Header and style

fprintf(fid,[...
'<!DOCTYPE html>\n'...
'<html>\n<head>\n'...
'<meta charset="UTF-8">\n'...
'<title>Talks Booklet</title>\n'...
'<style>\n'...
'@page {size:A4; margin:25mm;}\n'...
'body {\n'...
'font-family: Arial, Helvetica, sans-serif;\n'...
'font-size: 11pt;\n'...
'line-height:1.35;\n'...
'color:#222;\n'...
'}\n'...
'h1 {\n'...
'text-align:center;\n'...
'color:#1f4e79;\n'...
'margin-bottom:40px;\n'...
'}\n'...
'.session {\n'...
'font-size:15pt;\n'...
'font-weight:bold;\n'...
'color:#1f4e79;\n'...
'margin-top:30px;\n'...
'}\n'...
'.topic {\n'...
'font-size:12pt;\n'...
'font-style:italic;\n'...
'margin-bottom:15px;\n'...
'}\n'...
'.poster {\n'...
'margin-bottom:20px;\n'...
'page-break-inside:avoid;\n'...
'}\n'...
'.title {\n'...
'font-size:12pt;\n'...
'font-weight:bold;\n'...
'}\n'...
'.authors {\n'...
'margin-top:6px;\n'...
'}\n'...
'.aff {\n'...
'font-size:10pt;\n'...
'color:#555;\n'...
'margin-top:4px;\n'...
'}\n'...
'</style>\n'...
'</head>\n<body>\n'...
]);


fprintf(fid,'<h1>Talks Booklet</h1>\n');



%% ---------------- WRITE POSTERS ----------------

previousSession = "";


for k = 1:numel(talks)

    p = talks(k);


    % Define session identifier

    currentSession = sprintf('%s|%s|%s',...
        p.Day,...
        p.Time,...
        p.Topic);


    % New session

    if ~strcmp(currentSession,previousSession)


        fprintf(fid,...
            '<div class="session">%s &nbsp;&nbsp; %s</div>\n',...
            htmlEscape(p.Day),...
            htmlEscape(p.Time));


        fprintf(fid,...
            '<div class="topic">%s</div>\n',...
            htmlEscape(p.Topic));


        previousSession = currentSession;

    end



    %% Poster

    fprintf(fid,'<div class="poster">\n');


    % Title

    fprintf(fid,...
        '<div class="title">%s</div>\n',...
        htmlEscape(p.Title));



    %% Authors with superscript affiliations

    fprintf(fid,'<div class="authors">');


    authorList = strings(1,numel(p.Authors));


    for a = 1:numel(p.Authors)

        author = string(p.Authors(a).name);

        affNumbers = p.Authors(a).aff;


        affString = "";

        for j = 1:numel(affNumbers)

            affString = affString + ...
                sprintf('<sup>%d</sup>',affNumbers(j));

        end


        authorList(a) = author + affString;

    end


    fprintf(fid,'%s',...
        strjoin(authorList,", "));


    fprintf(fid,'</div>\n');



    %% Affiliations

    fprintf(fid,'<div class="aff">');


    for a = 1:numel(p.Affiliations)

        if a > 1
            fprintf(fid,';&nbsp;&nbsp;');
        end


        fprintf(fid,...
            '<sup>%d</sup> %s',...
            a,...
            htmlEscape(p.Affiliations(a)));

    end


    fprintf(fid,'</div>\n');


    fprintf(fid,'</div>\n');


end



%% Close HTML

fprintf(fid,...
'</body>\n</html>');


fclose(fid);


fprintf('\nCreated: %s\n',htmlFile);



%% ---------------- HTML ESCAPE ----------------

function s = htmlEscape(s)

    s = string(s);

    s = replace(s,"&","&amp;");
    s = replace(s,"<","&lt;");
    s = replace(s,">","&gt;");
    s = replace(s,'"',"&quot;");

    s = char(s);

end