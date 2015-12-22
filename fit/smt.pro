; generate final smooth background & the final
; background subracted map

; read raw map
;map = mrdfits("~/Projects/project_80032/NEW/45maps/I2_M31.NS.noCRs_mosaic.fits", 0, header)
map = mrdfits("~/Projects/project_80032/NEW/45maps/I2_M31.EW.big_mosaic.fits", 0, header)

; read hits map
;hits = mrdfits("~/Projects/project_80032/NEW/I1_M31.NS.noCRs_mosaic_cov.fits")
;hits2 = mrdfits("~/Projects/project_80032/NEW/45maps/I2_M31.NS.noCRs_mosaic_cov.fits")

hits1 = mrdfits("~/Projects/project_80032/NEW/I1_M31.EW.big_mosaic_cov.fits")
hits = mrdfits("~/Projects/project_80032/NEW/45maps/I2_M31.EW.big_mosaic_cov.fits")

hits=hits*hits1
; replace bad hits with 0s
nans_ind = where(finite(hits, /nan) or hits le 0) 
hits[nans_ind] = 0d
hits[where(hits gt 0)] = 1d

; read background model
;background = mrdfits('~/Projects/project_80032/NEW/45maps/finalbg_I1NS.fits')
background = mrdfits('~/Projects/project_80032/NEW/45maps/finalbg_I1EW.fits')

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

;fxwrite, '~/Projects/project_80032/NEW/45maps/I1NS_background_smooth.fits', header, $
;	float(background_smooth)
;fxwrite, '~/Projects/project_80032/NEW/45maps/I1NS_final_smooth.fits', header, float(cleaned)

fxwrite, '~/Projects/project_80032/NEW/45maps/I1EW_background_smooth.fits', header, $
        float(background_smooth)
fxwrite, '~/Projects/project_80032/NEW/45maps/I1EW_final_smooth.fits', header, float(cleaned)


end
