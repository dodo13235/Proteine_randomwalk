
function survived_statistics (walk_lenght,walk_number)
[walk_lenght]=Many_GSAW2d_statistics (walk_lenght,walk_number);
% PLOT SOPRAVVISUTI
figure (1)
  plot ( 1 : walk_lenght, trapped/walk_number*100,'r-', 'LineWidth', 2)
  title ( 'Length versus percentual of walks found.' );
  xlabel ( 'Length in steps' );
  ylabel ( '% of walks found' );
end
