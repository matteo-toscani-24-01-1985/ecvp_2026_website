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


%% ---------------- HTML HEADER ----------------

fprintf(fid,[...
'<!DOCTYPE html>\n'...
'<html>\n<head>\n'...
'<meta charset="UTF-8">\n'...
'<title>Talk Booklet</title>\n'...
'<style>\n'...
'@page {size:A4; margin:25mm;}\n'...
'body {\n'...
'font-family: Arial, Helvetica, sans-serif;\n'...
'font-size:11pt;\n'...
'line-height:1.35;\n'...
'color:#222;\n'...
'}\n'...
'h1 {\n'...
'text-align:center;\n'...
'color:#1f4e79;\n'...
'margin-bottom:40px;\n'...
'}\n'...
'.session {\n'...
'font-size:16pt;\n'...
'font-weight:bold;\n'...
'color:#1f4e79;\n'...
'margin-top:35px;\n'...
'}\n'...
'.room {\n'...
'font-size:11pt;\n'...
'font-style:italic;\n'...
'margin-bottom:15px;\n'...
'}\n'...
'.talk {\n'...
'margin-bottom:25px;\n'...
'page-break-inside:avoid;\n'...
'}\n'...
'.title {\n'...
'font-size:13pt;\n'...
'font-weight:bold;\n'...
'}\n'...
'.speaker {\n'...
'margin-top:7px;\n'...
'}\n'...
'.aff {\n'...
'font-size:10pt;\n'...
'color:#555;\n'...
'margin-top:5px;\n'...
'}\n'...
'</style>\n'...
'</head>\n<body>\n'...
]);


fprintf(fid,'<h1>Talk Booklet</h1>\n');



%% ---------------- WRITE TALKS ----------------

previousSession = "";


for k = 1:numel(talks)

    t = talks(k);


    % Session identifier
    % (time is not included, because it is displayed only once
    % when the session starts)

    currentSession = sprintf('%s|%s|%s',...
        t.Day,...
        t.Session,...
        t.Room);



    %% New session heading

    if ~strcmp(currentSession,previousSession)


        fprintf(fid,...
            '<div class="session">%s &nbsp;&nbsp; Beginning at %s</div>\n',...
            htmlEscape(t.Day),...
            htmlEscape(t.Time));


        fprintf(fid,...
            '<div class="room"><b>%s</b><br>Room: %s</div>\n',...
            htmlEscape(t.Session),...
            htmlEscape(t.Room));


        previousSession = currentSession;

    end



    %% Talk entry

    fprintf(fid,'<div class="talk">\n');


    % Title

    fprintf(fid,...
        '<div class="title">%s</div>\n',...
        htmlEscape(t.Title));



    %% Speaker and co-authors

    fprintf(fid,'<div class="speaker">');

    fprintf(fid,...
        '<b>%s</b>',...
        htmlEscape(t.Speaker));


    if isfield(t,'CoAuthors') && ~isempty(t.CoAuthors)

        fprintf(fid,...
            ', %s',...
            htmlEscape(t.CoAuthors));

    end


    fprintf(fid,'</div>\n');



    %% Authors with affiliation numbers

    if isfield(t,'Authors') && ~isempty(t.Authors)

        fprintf(fid,'<div class="speaker">');


        authorList = strings(1,numel(t.Authors));


        for a = 1:numel(t.Authors)

            name = string(t.Authors(a).name);

            affNumbers = t.Authors(a).aff;


            superscript = "";

            for j = 1:numel(affNumbers)

                superscript = superscript + ...
                    sprintf('<sup>%d</sup>',affNumbers(j));

            end


            authorList(a) = name + superscript;

        end


        fprintf(fid,'%s',...
            strjoin(authorList,", "));


        fprintf(fid,'</div>\n');

    end



    %% Affiliations

    if isfield(t,'Affiliations') && ~isempty(t.Affiliations)


        fprintf(fid,'<div class="aff">');


        for a = 1:numel(t.Affiliations)

            if a > 1
                fprintf(fid,';&nbsp;&nbsp;');
            end


            fprintf(fid,...
                '<sup>%d</sup> %s',...
                a,...
                htmlEscape(t.Affiliations{a}));

        end


        fprintf(fid,'</div>\n');


    end



    fprintf(fid,'</div>\n');


end



%% ---------------- CLOSE HTML ----------------

fprintf(fid,...
'</body>\n</html>');


fclose(fid);


fprintf('\nCreated: %s\n',htmlFile);



%% ---------------- HTML ESCAPE FUNCTION ----------------

function s = htmlEscape(s)

    s = string(s);

    s = replace(s,"&","&amp;");
    s = replace(s,"<","&lt;");
    s = replace(s,">","&gt;");
    s = replace(s,'"',"&quot;");

    s = char(s);

end