function [ ret_amp, ret_phase ] = utils_get_phaseamp( lfpsnow, fphase, famp, fs )
    ret_amp = nan( size( lfpsnow ) ); 
    ret_phase = ret_amp;
    for m = 1 : size( lfpsnow, 1 )
        aux = lfpsnow( m, : ); 
        aux_ph = butter_filter( aux, 4, fphase(1), fphase(2), 'bandpass', fs );
        aux_amp = butter_filter( aux, 4, famp(1), famp(2), 'bandpass', fs );
        aux_ph = angle( hilbert( aux_ph ) );
        aux_amp = abs( hilbert( aux_amp ) );
        ret_phase( m, : ) = aux_ph;
        ret_amp( m, : ) = aux_amp;
    end
end