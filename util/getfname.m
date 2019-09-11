function [ filenameout ] = getfname( stringin )
%GETFNAME Get name of file without path or extension
%   Outputs the second argument of fileparts.m.
[junk filenameout] = fileparts(stringin);


end

