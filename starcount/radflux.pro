; compute the flux (source count) in radial bins
; © Masoud Rafiei Ravandi
;	<mrafiei.ravandi@gmail.com>
; -----
scale = 1.1999988; arcsec/pixel
cra = 10.684709 ; galactic center - RA
cdec = 41.268803 ; galactic center - DEC
bin = 13 & dr = 500 & mincut = 4100 ; radial bin settings 
centre = [10750, 1500] ; galactic center - pixel coordinates -- EW (major-axis) image

; ----- read image headers
; EW image
ew_header = headfits('~/Projects/Andromeda/pr_maps/I1EW.fits')
; mosaic (made by MONTAGE)
mos_header = headfits('/Users/mrafieir/Projects/Andromeda/mosaics/products/bgSubtracted/mosaic_area.fits')

; area values in each radial bin
readcol, "~/Projects/Andromeda/pros/starcount/dats/area.dat", rcount_area, area, format='d,d'

; source catalog
;readcol, '/Users/mrafieir/Projects/Andromeda/pros/fgr/b13', $
readcol, '~/Projects/Andromeda/pros/comm/fbgr/CleanCat_Tri.prt', $
ra, dec, irac2, colirac, probcol, format='d,d,d,d,d'

; constraints on magnitude
index = where( (irac2 gt 14) AND (irac2 le 18) )
ra = ra[index] & dec = dec[index] & irac2 = irac2[index] & colirac = colirac[index]
probcol = probcol[index]

; convert ra/dec to pixel coordinates on mosaic
adxy, mos_header, ra, dec, x, y
x = fix(x) & y = fix(y)

; convert pixel coordinates (center in EW image) to ra/dec
xyad, ew_header, centre[0], centre[1], cra, cdec

; convert ra/dec (center in EW image) to pixel coordinates on mosaic
adxy, mos_header, cra, cdec, cx, cy
cx = fix(cx) & cy = fix(cy)

; radial dist from the center on mosaic
r = findgen(bin)*dr + mincut
; pick the center of radii
rcount = r - dr/2.
rcount = rcount[1:*]
; make sure that the area values (read earlier) correspond to the same radii
if array_equal(rcount_area, rcount) then begin

	; flux bins
	flux = dblarr(bin)
	; radial distance from the center of mosaic
	rdist = sqrt((x-cx)^2d + (y-cy)^2d)
	; count # sources, hence flux at each radial bin
	for i = 0, bin-2 do begin

		ind = where((rdist ge r[i]) AND (rdist lt r[i+1]), count)
		flux[i] = total(probcol[ind], /double, /nan)
	; print loop status
	print, 'loop,', bin-2-i
	endfor

	flux = flux[0:bin-2]

endif else print, 'rcount arrays must be equal!'
; print the result into file
forprint, rcount, flux, area, text="fscount", /nocomment

END
