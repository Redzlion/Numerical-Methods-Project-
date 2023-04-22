function displayComparison(w)
    precision = 0.2; % Specified precision for comparison

    fprintf('---------------------------------------------------\n')

    fprintf('Polynomial: '); displayPolynomial(w); fprintf('\n');
    % Find the roots using the findRoots function
    myFunctionRoots = findRoots(w);
    % Find the roots using the built-in roots function
    builtinFunctionRoots = roots(w);
    % Extract the real roots
    for n=1:length(builtinFunctionRoots)
        if abs(imag(builtinFunctionRoots(n)))>0
            builtinFunctionRoots(n) = NaN;
        end
        builtinFunctionRoots(n) = real(builtinFunctionRoots(n));       
    end
    builtinFunctionRoots=builtinFunctionRoots(~isnan(builtinFunctionRoots));

    myFunctionRoots = sort(myFunctionRoots);
    builtinFunctionRoots = sort(builtinFunctionRoots');

    % Display the real roots found by both methods
    fprintf('Real roots found by findRoots: %d\n',length(myFunctionRoots));
    for i=1:length(myFunctionRoots)
        fprintf('x%d= %.3g\n', i, myFunctionRoots(i));
    end
    fprintf('\nReal roots found by built-in roots function: %d\n', length(builtinFunctionRoots));
    for i=1:length(builtinFunctionRoots)
        fprintf('x%d= %.3g\n', i, builtinFunctionRoots(i));
    end

    % Compare the real roots found by both methods
    matching_roots = 0;
    for j = 1:length(myFunctionRoots)
        for k = 1:length(builtinFunctionRoots)
            if abs(myFunctionRoots(j) - builtinFunctionRoots(k)) < precision
                matching_roots = matching_roots + 1;
                break;
            end
        end
    end

    fprintf('\nNumber of matching roots found in both functions: %d\n', matching_roots);

    fprintf('---------------------------------------------------\n')
end