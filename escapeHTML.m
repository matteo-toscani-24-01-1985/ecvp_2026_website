function s = escapeHTML(s)

    if isstring(s)
        s = char(s);
    end

    s = strrep(s,'&','&amp;');
    s = strrep(s,'<','&lt;');
    s = strrep(s,'>','&gt;');
    s = strrep(s,'"','&quot;');

end