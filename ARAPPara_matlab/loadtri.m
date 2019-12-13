function [pnt, dhk] = loadtri(fn);
%function [pnt, dhk] = loadtri(fn);

fn=fn(fn~=' ');

fid = fopen(fn, 'rt');
if fid~=-1

  % read the vertex points
  Npnt = fscanf(fid, '%d', 1);
  pnt  = fscanf(fid, '%f', [4, Npnt]);
  pnt  = pnt(2:4,:)';

  % if present, read the triangles
  if (~(feof(fid)))
    [Ndhk, count] = fscanf(fid, '%d', 1);
    if (count ~= 0)
      dhk = fscanf(fid, '%d', [4, Ndhk]);
      dhk = dhk(2:4,:)';
    end
  else
    dhk = [];
  end
  fclose(fid);

else
  error('unable to open file');
end

