; generate final smooth background & the final
; background subracted map

; read raw map
map = mrdfits("../maps/I1_M31.NS.noCRs_mosaic.fits", 0, header)

; read hits map
hits = mrdfits("../maps/I1_M31.NS.noCRs_mosaic_cov.fits")

; replace bad hits with 0s
nans_ind = where(finite(hits, /nan) or hits le 0) 
hits[nans_ind] = 0d
hits[where(hits gt 0)] = 1d

; read background model
background = mrdfits('../NEW/finalbg_I1NS.fits')
; replace all of the (above) bad-hit pixels with NANs
background[nans_ind] = !Values.F_NAN
; smooth the background -- ignoring NANs
background_smooth = filter_image(background, smooth=199)

; replace (previous) NANs with 0s
background_smooth[nans_ind] = 0

; make a cleaned map using the smooth bakground
cleaned = (map - background_smooth) * hits
; replace NANs (again) with NANs
cleaned[nans_ind] = !Values.F_NAN
stop
fxwrite, '../NEW/I1NS_background_smooth.fits', header, $
	float(background_smooth)
fxwrite, '../NEW/I1NS_final_smooth.fits', header, float(cleaned)

end
