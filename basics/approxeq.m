function isit = approxeq(x, y, tolerance) 
% Checks whether values are nearly equal, to within tolerance. 
% Similar to   "==", this returns either 1 for true or 0 for false,
% but here we report whether or not the values are nearly equal.
% Typical applications are in matching rough calculations to target values,
% and eliminating floating-point precision limits from equality tests.
% Inputs:
%	x,y: numbers to compare. These can be scalar or arrays. See notes below
%	tolerance: how much difference to allow. Default is sqrt(machine limit)
% Output:
%	a vector of 1s and 0s of length equal to the longer of x and y
% Notes:
%	Typically one enters equal-size x and y, but 'recycling' is allowed.
%	"Recycling" means the shorter variable is repeated until it's as long
%	as the other variable.  This feature allows, for example, comparison of
%	each column of y with the values in a single-column x.
%
%input validation 
x = reshape(x,numel(x),1);
y = reshape(y,numel(y),1);
if (length(x) ~= length(y)),
	warning('x,y lengths differ. Will recycle.');
	dorep = max(numel(x),numel(y));
	xlong = repmat(x, ceil(dorep/numel(x)),1);
	ylong = repmat(y, ceil(dorep/numel(y)),1);
	x = xlong(1:dorep);
	y = ylong(1:dorep);
end
if ~exist('tolerance','var'),
	tolerance = sqrt(eps); %currently eps = 2E-16
end
% just in case...
tolerance = tolerance(1);
isit = (abs(x-y) < tolerance) ;
end