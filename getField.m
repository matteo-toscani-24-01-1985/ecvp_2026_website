% -------- helper function --------
function value = getField(obj, field)

    pattern = ['"' field '"\s*:\s*"(.*?)"'];
    token = regexp(obj, pattern, 'tokens');

    if ~isempty(token)
        value = token{1}{1};
    else
        % Handle numeric fields
        pattern = ['"' field '"\s*:\s*([0-9]+)'];
        token = regexp(obj, pattern, 'tokens');

        if ~isempty(token)
            value = token{1}{1};
        else
            value = '';
        end
    end

end