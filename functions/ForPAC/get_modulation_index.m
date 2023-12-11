function MIret = get_modulation_index( phdata, ampdata )
% This basically does what is described by Petkov in his PAC methodology,
% in the paper Kikuchi et al. 2017 (Plos Bio). But here we only calculate the
% Modulation index itself. The preprocessing of the data should have been
% done above (ERP subtraction, etc....). See also van Driel et al. 2015

    PhClus = sum( exp( 1i .* phdata(:) ) ) ./ numel( phdata );
    zt = ampdata(:) .* ( exp( 1i .* phdata(:) ) - PhClus );
    MIret = abs( sum( zt ) ./ numel( zt ) ); 
end