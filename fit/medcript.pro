; generate 'clean.fits' map
; containing median values of 100x100 pixels

; read the mask (0s and 1s)
mask = mrdfits('~/Projects/Andromeda/NEW/mask_I1NS.fits')
; read the background map (i.e. raw map masked by the mask above)
bg = mrdfits('~/Projects/Andromeda/NEW/bg_I1NS.fits', 0, header)

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
readcol, '~/Projects/Andromeda/cats/mask_data/I1ns_extrapos.dat', $
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

fxwrite, '~/Projects/Andromeda/NEW/clean_I1NS.fits', header, float(bg)
end