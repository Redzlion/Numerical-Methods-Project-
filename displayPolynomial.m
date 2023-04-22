function displayPolynomial(w)
    n = length(w);
    str = '';
    for i = 1:n
        if w(i) ~= 0
            if i == n
                if w(i) > 0 && i ~= 1
                    str = sprintf('%s+%d', str, w(i));
                else
                    str = sprintf('%s%d', str, w(i));
                end
            elseif i == n-1
                if w(i) > 0 && i ~= 1
                    str = sprintf('%s+%dx', str, w(i));
                else
                    str = sprintf('%s%dx', str, w(i));
                end
            else
                if w(i) > 0 && i ~= 1
                    str = sprintf('%s+%dx^%d', str, w(i), n-i);
                else
                    str = sprintf('%s%dx^%d', str, w(i), n-i);
                end
            end
        end
    end
    fprintf('%s = 0\n', str);
end