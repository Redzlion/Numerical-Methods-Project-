function roots = findRoots(w)
    roots = findRootsPart(w);
    roots = mergeSimilarValues(roots, 0.15); % merges values too similar with specified precision
end

function roots = findRootsPart(w)
    n = length(w) - 1; % Degree of polynomial
    
    % finds roots when polynomial has 2 non zero coefficients
    if nnz(w)==2
        indx = findTwoNonZeroValues(w);
        roots = [nthroot(-w(indx(2))/w(1),n-(length(w)-indx(2)))];
        if mod((n-(length(w)-indx(2))),2) == 0
            roots = [-roots, roots];
        end
        if indx(2)~=length(w) % checks if zero is a root
            roots = [roots, 0];
        end
        return % exits the function
    end

    % Creating the companion matrix by filling the sub-diagonal with 1's and first row with
    % the negative of the coefficients of the polynomial divided by the first coefficient
    C = diag(ones(n-1,1),-1);
    C(1,:) = -w(2:n+1) ./ w(1); 

    % Initial guess for eigenvector
    x = rand(n,1); % generating a random vector of size nx1

    % Power method
    tol = 1e-9; % Tolerance for convergence
    maxIter = 1000000; % Maximum number of iterations
    lambda = 0; % Initialize eigenvalue
    for i = 1:maxIter
        y = C*x;
        lambda_new = norm(y);
        if abs(lambda - lambda_new) < tol
            break; % breaks the loop if the difference between the current eigenvalue and the next eigenvalue is smaller than the tolerance
        end
        x = y / lambda_new;
        lambda = lambda_new;
    end

    % Deflate polynomial
    roots = [];
    wTemp = w;
    for i = 1:n
        roots(i) = x(i) / x(n); % dividing each element of the eigenvector by the last element of the eigenvector to get an approximation of the roots
        [wTemp2, check] = polydeflate(wTemp,roots(i)); % calling the polydeflate function to deflate the polynomial and check if the current root is a valid root
        if check==true
            wTemp=wTemp2; % if the root is valid, update the polynomial
        else
            roots(i) = NaN; % if the root is not valid, set the root to NaN
        end
    end
    
    roots = roots(~isnan(roots)); % remove any NaN values from the roots array
    if isempty(roots)
        return % exits the function if there are no valid roots
    end

    wTemp = w;
    
    for i = 1:length(roots)
        wTemp = polydeflate(wTemp,roots(i)); % deflate the polynomial for each valid root
    end

    if length(wTemp)>=2
        rootsTemp = findRootsPart(wTemp); % recursively call the findRoots function on the deflated polynomial       
        if ~isempty(rootsTemp)
            roots = [roots, rootsTemp]; % merge the roots of the original polynomial and the deflated polynomial
        end
    end
end

function [deflated, isRoot] = polydeflate(w,root)
    n = length(w); % Degree of polynomial
    deflated=[w(1)];
    % Horner's algorithm
    for i = 2:n
        deflated(i)=w(i)+deflated(i-1)*root; % deflating the polynomial using Horner's algorithm
    end
    
    tol = 1;  % Tolerance for checking if the root is valid
    if abs(deflated(end)) >= tol
        isRoot = false; % if the last element of the deflated polynomial is greater than the tolerance, the root is not valid
    else
        deflated(end)=[];
        isRoot = true; % if the last element of the deflated polynomial is less than the tolerance, the root is valid
    end
end

function positions = findTwoNonZeroValues(vector)
    count = 0;
    positions = [];
    for i = 1:length(vector)
        if vector(i) ~= 0
            count = count + 1;
            positions(count) = i;
        end
    end
    if count ~= 2
        positions = []; % reset positions to an empty array if the number of non-zero values is not equal to 2
    end
end

function new_vec = mergeSimilarValues(vec, tolerance)
    new_vec = vec;
    while true
        merge_occured = false;
        for i = 1:length(new_vec)
            for j = i+1:length(new_vec)
                if abs(new_vec(i) - new_vec(j)) < tolerance
                    if round(new_vec(i)) == new_vec(i)
                        new_vec(j) = NaN;
                        merge_occured = true;
                    elseif round(new_vec(j)) == new_vec(j)
                        new_vec(i) = NaN;
                        merge_occured = true;
                    else
                        if abs(new_vec(i) - round(new_vec(i))) < abs(new_vec(j) - round(new_vec(j)))
                            new_vec(j) = NaN;
                        else
                            new_vec(i) = NaN;
                        end
                        merge_occured = true;
                    end
                end
            end
        end
        new_vec = new_vec(~isnan(new_vec));
        if merge_occured == false
            break;
        end
    end
end