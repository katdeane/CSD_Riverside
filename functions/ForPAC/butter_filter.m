function filt_sig = butter_filter( signal, order, lf, hf, type, fs )

    % This function performs filtering of input signal, specified order,
    % low freq cut off, hig freq cutoff... type is 'bandpass' and so on. Fs
    % is the sampling frequency. Uses filtfilt to avoid phase shifting...
    % Always use with the 6 proper params, please..
    
    if ( nargin ~= 6 )
        error( 'You should have six input parameters. Check this' );
        return;
    end
    
    Wn = [ lf hf ] ./ ( fs / 2 ); % non-dimensional scale frequency
%     [b, a] = butter( order, Wn, type );
    [ z, p, k ] = butter( order, Wn, type );
    [ sos, g ] = zp2sos( z, p, k );
%     filt_sig = filtfilt( b, a, signal ); % filtfilt zero phase shift
    filt_sig = filtfilt( sos, g, signal );
end