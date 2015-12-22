; generate finalbg.fits
; final 1-step-smoothed background

; read the map
;map_path = '~/Projects/project_80032/NEW/45maps/clean_I1NS.fits'
map_path = '~/Projects/project_80032/NEW/45maps/clean_I1EW.fits'
map = mrdfits(map_path, 0, header)

; read the elliptical mask covering the galaxy
;ellmask = mrdfits('~/Projects/project_80032/NEW/ellmask_I1NS.fits')
ellmask = mrdfits('~/Projects/project_80032/NEW/IRAC1_EW/ellmask.fits')

; read the hits map and replace bad pixels with 0s
;hits = mrdfits("~/Projects/project_80032/NEW/I1_M31.NS.noCRs_mosaic_cov.fits")
hits = mrdfits("~/Projects/project_80032/NEW/I1_M31.EW.big_mosaic_cov.fits")

nans_ind = where(finite(hits, /nan) or hits le 0)
hits[nans_ind] = 0d
hits[where(hits gt 0)] = 1d


; read the hits map and replace bad pixels with 0s
;hits1 = mrdfits("~/Projects/project_80032/NEW/45maps/I2_M31.NS.noCRs_mosaic_cov.fits")
hits1 = mrdfits("~/Projects/project_80032/NEW/45maps/I2_M31.EW.big_mosaic_cov.fits")

nans_ind = where(finite(hits1, /nan) or hits1 le 0)
hits1[nans_ind] = 0d
hits1[where(hits1 gt 0)] = 1d

hits = hits * hits1

; make a master mask using the elliptical mask 
; and the hits map
ellmask = 1d - ellmask
mask = hits * ellmask

; extract map dimensions
dims = size(map, /dim)
nx = dims[0] & ny = dims[1]

; initialize arrays for fitting
x = findgen(nx)
y = findgen(ny)

; poly fit order
order = 3
depth = 20

rx = 0
ry = 0
for h = 0, ny-1 do begin
	xmask = x
	xmask[*] = ellmask[*, h]
	good = where(xmask eq 1, count)
	if (count gt 0) then begin
            xbg = map[*,h]

; \\\\\\\\\\
	bad = where(xmask eq 0, count_bad)
	if (count_bad gt 2) then begin
		ept_xmask = minmax(bad)	; endpoints index

		fpt = ept_xmask[0]-depth
		spt = ept_xmask[1]+depth

for k = 1, 6 do begin

if xbg[fpt] eq 0 then fpt = fix( -k * 100 + fpt )
if xbg[spt] eq 0 then spt = fix( k * 100 + spt )

endfor

	ept_xbg = [ xbg[fpt], xbg[spt] ] ; values in map

	
	ept_x = [ x[fpt], x[spt] ] ; values in x
	
	coeff = linfit(ept_x, ept_xbg, /double)
	map[fpt:spt,h] = coeff[0] + coeff[1] * x[fpt:spt]
endif
; \\\\\\\\\\

endif else begin
         map[*,h] = 0.
            rx = rx + (h+1) / (h+1)
      endelse
print, ny-1-h
endfor

mapx = map
map = mrdfits(map_path, 0, header)

for h = 0, nx-1 do begin
        ymask = y
        ymask[*] = ellmask[h, *]
        good = where(ymask eq 1, count)
        if (count gt 0) then begin
               ybg = map[h, *]

; \\\\\\\\\\
        bad = where(ymask eq 0, count_bad)
        if (count_bad gt 2) then begin                
		ept_ymask = minmax(bad) ; endpoints index        
                fpt = ept_ymask[0]-depth
                spt = ept_ymask[1]+depth

for k = 1, 6 do begin

if ybg[fpt] eq 0 then fpt = fix( -k * 100 + fpt )
if ybg[spt] eq 0 then spt = fix( k * 100 + spt )

endfor

                ept_ybg = [ ybg[fpt], ybg[spt] ] ; values in map
        
                ept_y = [ y[fpt], y[spt] ] ; values in y

                coeff = linfit(ept_y, ept_ybg, /double)
                map[h,fpt:spt] = coeff[0] + coeff[1] * y[fpt:spt]
        endif
; \\\\\\\\\\

        endif else begin
               map[h, *] = 0.
               ry = ry + (h+1) / (h+1)
        endelse
print, nx-1-h
endfor

finalbg = (mapx+map)/2d

;finalbg = map
;map = mrdfits("~/Projects/project_80032/NEW/I1_M31.NS.noCRs_mosaic.fits", 0, header)
map = mrdfits("~/Projects/project_80032/NEW/I1_M31.EW.big_mosaic.fits", 0, header)

;fxwrite, '~/Projects/project_80032/NEW/45maps/finalbg_I1NS.fits', header, float(finalbg)
fxwrite, '~/Projects/project_80032/NEW/45maps/finalbg_I1EW.fits', header, float(finalbg)

end
