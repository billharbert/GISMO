function c = deconv(c)

% c = DECONV(c) convolves all traces with the final trace. By default the new
% correlation object has traces that are 2*N-1 samples long, where the
% original traces are of length N. Because all traces ...
% 
% ** NOTE TO USERS: Though most plotting routines normalize adjacent traces
% to comparable amplitudes for display, the real trace amplitudes often
% very by orders of magnitudes. Depending on the features the user is
% trying to highlight, it may make sense to normalize the trace amplitudes
% before stacking. This can be performed with the NORM function.

% Author: Michael West, Geophysical Institute, Univ. of Alaska Fairbanks
% $Date$
% $Revision$





error('This code is not yet functional. Sorry - MEW');


% GENERAL PARAMETERS
c = unifytracelengths(c);
keyTrace = c.ntraces;


X = fft(double(c.traces));      % all traces       
Y = repmat( fft(double(c.traces(keyTrace))) , 1 , c.ntraces );   % single trace 




%Z = ifft(X ./ Y);  
e = 0.01 * sum(abs(Y(:,1)).^2);
numerator = X .* conj(Y) ;
denominator = abs(Y).^2 + e ;
%denominator = Y .* conj(Y) + e ;
Z = ifft( numerator ./ denominator );

save

for n = 1:c.ntraces
   c.traces(n).data = Z(:,n);
end
end
