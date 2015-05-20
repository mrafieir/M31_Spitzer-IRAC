function flxmeasure, map, o_centre, w, d, level, axi, boot, scale

n = n_elements(w)
flux = dblarr(n)
uflux_err = dblarr(n)
lflux_err = dblarr(n)

for i = 0, n-1 do begin
	
	i1 = fix( d[i] - w[i]/2d )
	f1 = fix( d[i] + w[i]/2d )
	i2 = fix( o_centre - w[i]/2d )
	f2 = fix( o_centre + w[i]/2d )
	
	case axi of
		0: s = map[i1:f1,i2:f2]
		1: s = map[i2:f2,i1:f1]
		else: print, 'axis must be selected!'
	endcase

	f_ind = where(finite(s), count)
	if count gt 0 then begin
		s = s[f_ind]

		;flux_s = median(s)
		;sigma = rmsdev(flux_s, s, 0)
		; reject points above level
		
		;sigma = bootstrap_median(s, conflimit=level, nboot=boot)
		;flux_s = sigma[1]
		;uflux_s = sigma[2]
		
		sigma = bootstrap_median2(s, n_iter=boot)
		flux_s = sigma[0]
		sigma = sigma[1]

		b_ind = where(s lt flux_s+level*sigma)
		;b_ind = where(s lt uflux_s)
		;flux[i] = median(s[b_ind])
		;noise = rmsdev(flux[i], s[b_ind], 1)
		
		;sigma = bootstrap_median(s[b_ind], conflimit=0.68, nboot=boot)
		;flux[i] = sigma[1]
		;ulimit = sigma[2]-sigma[1]
		;llimit = sigma[1]-sigma[0]
		
		sigma = bootstrap_median2(s[b_ind], n_iter=boot)
		flux[i] = sigma[0]
		ulimit = sigma[1]
		llimit = sigma[1]
	;	flux[i] = mean(s[b_ind])
	;	ulimit = rmsdev(flux[i], s[b_ind], 1)
	;	llimit = ulimit
		
		uflux_err[i] = abs(1d - ulimit/flux[i])
		lflux_err[i] = abs(1d - llimit/flux[i])
	print, n-1-i
	endif else begin
	flux[i] = !values.f_nan & uflux_err[i] = !values.f_nan & lflux_err[i] = $
	!values.f_nan
	endelse
endfor

; aperture correction
apcor = 0.91d
ap = w * sqrt(2d) * scale ; diagonal in arcsec
aplim = 5d * 60d ; arcsec limit on infinite aper correction ---> 5'
ind = where( ap ge aplim )
cflux = flux
cflux[ind] = flux[ind] * apcor
uflux_err[ind] = sqrt((uflux_err[ind]/flux[ind])^2d + 0.1^2d) * cflux[ind]
lflux_err[ind] = sqrt((uflux_err[ind]/flux[ind])^2d + 0.1^2d) * cflux[ind]

return, [[cflux],[uflux_err],[lflux_err]]
end
