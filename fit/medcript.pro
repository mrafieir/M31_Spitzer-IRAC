; generate 'clean.fits' map
; containing median values of 100x100 pixels

; read the mask (0s and 1s)
;mask = mrdfits('~/Projects/project_80032/NEW/mask_I1NS.fits')
mask = mrdfits('~/Projects/project_80032/NEW/IRAC1_EW/I1EW_mask.fits')

; read the background map (i.e. raw map masked by the mask above)
;bg = mrdfits('~/Projects/project_80032/NEW/45maps/I2_M31.NS.noCRs_mosaic.fits', 0, header)
bg = mrdfits('~/Projects/project_80032/NEW/45maps/I2_M31.EW.big_mosaic.fits', 0, header)

;hits1 = mrdfits("~/Projects/project_80032/NEW/I1_M31.NS.noCRs_mosaic_cov.fits")
hits1 = mrdfits("~/Projects/project_80032/NEW/I1_M31.EW.big_mosaic_cov.fits")
nans_ind = where(finite(hits1, /nan) or hits1 le 0)
hits1[nans_ind] = !VALUES.F_NAN
hits1[where(hits1 gt 0)] = 1d

;hits = mrdfits("~/Projects/project_80032/NEW/45maps/I2_M31.NS.noCRs_mosaic_cov.fits")
hits = mrdfits("~/Projects/project_80032/NEW/45maps/I2_M31.EW.big_mosaic_cov.fits")
nans_ind = where(finite(hits, /nan) or hits le 0)
hits[nans_ind] = !VALUES.F_NAN 
hits[where(hits gt 0)] = 1d

mask = mask * hits * hits1
bg = bg * mask

;********************
; extract map dimensions 
dims = size(bg, /dim)
nx = dims[0] & ny = dims[1]

; the width of 'median' tiles
side = fix(100)

; total area (in # pixels) of the map
area = nx * ny

; how many tiles needed to cover that area
ntile = fix(area / side^2)

; how many tiles to cover x
nxtile = fix(nx/side)

; how many tiles to cover y
nytile = fix(ny/side)

; tile dimensions
tdims = [side, side]

; loop over all tiles, use the mask 
; as a refernce, and find the median values 
for jx = 0, nxtile-1 do begin
	for jy = 0, nytile-1 do begin
		; tile in mask
		tmask = mask[side*jx:side*(jx+1)-1, $
				side*jy:side*(jy+1)-1]
		; the same tile (location) but in background map
		tbg = bg[side*jx:side*(jx+1)-1, $
                                side*jy:side*(jy+1)-1]
		; good indeces are unmasked
		goodind = where(tmask eq 1, count)
		if (count gt 0) then begin ; if there is any good pixel
		;xy = array_indices(tdims, goodind, /dimen)
		;x = reform(xy[0,*])
		;y = reform(xy[1,*])
		z = tbg[goodind]	; an array of all good pixels
		
		;fitsurf = grid_tps(x, y, z, ngrid=tdims, start=[0,0], $
		;			delta=[1,1])
		; replace the tile in backgrond map with the median value
		; of good pixels 
		bg[side*jx:side*(jx+1)-1, side*jy:side*(jy+1)-1] = $;fitsurf
		median(z)		
endif
	print, (nytile-1) - jy
	endfor
print, (nxtile-1) - jx
endfor

; extra
; after inspecting the result, we find some areas that could be filled in
; with the mean of their neighbourhood..

;readcol, '~/Projects/project_80032/cats/mask_data/I1ns_extrapos.dat', $
;	xi, xf, yi, yf, comment='#'
readcol, '~/Projects/project_80032/cats/mask_data/I1ew_extrapos.dat', $
        xi, xf, yi, yf, comment='#'


xi = fix(xi) & xf = fix(xf) & yi = fix(yi) & yf = fix(yf)

 for z = 0, n_elements(xi)-1 do begin

        a = bg[xi[z]:xf[z],yi[z]:yf[z]]
	ind_a = where(a ne 0)
	mean_a = mean(a[ind_a], /double, /nan)

	a[where(a eq 0)] = mean_a
	bg[xi[z]:xf[z],yi[z]:yf[z]] = a
	
;        bg[xi[z]+side:xf[z]-side,yi[z]+side:yf[z]-side] = mean_a

print, z, mean_a
 endfor

;fxwrite, '~/Projects/project_80032/NEW/45maps/clean_I1NS.fits', header, float(bg)
fxwrite, '~/Projects/project_80032/NEW/45maps/clean_I1EW.fits', header, float(bg)
end
