function CC = extreme(data,conn,q)
% THIS CODE FILE HAS TO BE SAVED AS extremes.m TO BE EXECUTABLE IN MATLAB!
% Computes connected extremes in data that exceed a certain quantile q.
% By Jakob Zscheischler, jzsch@bgc-jena.mpg.de, 15.01.2013
% Max Planck Institute for Biogeochemistry, Jena, Germany
%
% !!! This function requires the Image Processing toolbox !!!
%
% Input:
% data: 2D or 3D data set where to look for extremes, typically anomalies, 
%       missing values should be NaN
% conn: connectivity, necessary for bwconncomp, defines when 2 nodes are 
%       connected, use 4 or 8 for 2D data and 6, 18 or 26 for 3D data
% q:	quantile (0 < q < 1)
%
% Output:
% CC:	CC.PixelIdxList contains a list of vectors, each of them containing 
%       the indices of one contiguous extreme event

% test for number of input arguments
if nargin~=3
    disp('Three input arguments are expected.')
    CC = [];
    return
end

% test whether the quantile is in the right range
if q <= 0 || q >= 1
    disp('The percentile muss by >0 and <1.')
    CC = [];
    return
end

% test whether the connectivity is right for 3D data
if numel(size(data))==3 && ~ismember(conn,[6,18,26])
    disp('For 3D data sets the connectivity must be 6, 18, or 26.')
    CC = [];
    return
end

% test whether the connectivity is right for 2D data
if numel(size(data))==2 && ~ismember(conn,[4,8])
    disp('For 2D data sets the connectivity must be in 4 or 8.')
    CC = [];
    return
end

% where are the data?
idx_data = ~isnan(data);

% get threshold from quantile
limit = quantile(data(idx_data), q);

% allocate space
binary_anomaly = zeros(size(data));
    
% searching for positive or negative extremes?
if q <= 0.5
   binary_anomaly(data < limit) = 1;
else
   binary_anomaly(data > limit) = 1;
end
    
% transform the array to logical values
binary_anomaly = logical(binary_anomaly);
    
% identify the connected components in 3d
CC = bwconncomp(binary_anomaly, conn);
return
end