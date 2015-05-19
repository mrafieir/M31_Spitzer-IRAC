; compute area in radial bins
scale = 1.1999988 ; arcsec/pixel
cra = 10.684709
cdec = 41.268803
bin = 16 & dr = 475 & mincut=3000
centre = [10750, 1500]

;map = mrdfits('~/Projects/project_80032/mosaics/products/bgSubtracted/mosaic_area.fits', 0, header)
map = mrdfits('~/Projects/project_80032/maps/hit_ew.fits', 0, header)
dims = fix(size(map, /dim))

; initiating the centre
adxy, header, cra, cdec, cx, cy
cx = fix(cx) & cy = fix(cy)

; making a ref map for radial dist
refmap = dist(dims[0], dims[1])
refmap = shift(refmap, cx, cy)
fxwrite, "./refmap_ew.fits", header, float(refmap)
;refmap = mrdfits('~/Projects/project_80032/inmaps/refmap.fits')

; radial dist
r = findgen(bin)*dr + mincut
rcount = r - dr/2.
rcount = rcount[1:*]
; area bins
area = dblarr(bin)

for i = 0, bin-2 do begin
        a = map[where((refmap ge r[i]) and (refmap lt r[i+1]))]
        ind_cov = where(a eq 1, count_cov)
        area[i] = count_cov*scale^2d
print, 'loop, ', bin-2-i
endfor
area = area[0:bin-2]

forprint, rcount, area, text="area_ew", /nocomment
END
