function s = escapeJS(s)

if isempty(s)
    s = '';
    return
end

if iscell(s)
    s = s{1};
end

s = char(s);

s = strrep(s,'\','\\');
s = strrep(s,'"','\"');
s = strrep(s,newline,'\n');
s = strrep(s,char(13),'');
s = strrep(s,char(10),'\n');

end