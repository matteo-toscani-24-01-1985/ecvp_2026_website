
function s = formatAbstract(txt)

    if isstring(txt)
        txt = char(txt);
    end

    txt = escapeHTML(txt);

    % preserve paragraphs
    txt = regexprep(txt,'\n\s*\n','</p><p>');

    s = ['<p>' txt '</p>'];

end