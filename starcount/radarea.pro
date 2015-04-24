; compute area in radial bins
scale = 1.1999988 ; arcsec/pixel
cra = 10.684709
cdec = 41.268803
bin = 13 & dr = 500 & mincut=4100
centre = [10750, 1500]

map = mrdfits('../mosaics/products/bgSubtracted/mosaic_area.fits', 0, header)

; initiating the centre
adxy, header, cra, cdec, cx, cy
cx = fix(cx) & cy = fix(cy)

; making a ref map for radial dist
;refmap = dist(dims[0], dims[1])
;refmap = shift(refmap, cx, cy)
;fxwrite, "./inmaps/refmap.fits", header, float(refmap)
refmap = mrdfits('../inmaps/refmap.fits')

; radial dist
r = findgen(bin)*dr + mincut
rcount = r - dr/2.
rcount = rcount[1:*]
; area bins
area = dblarr(bin)

for i = 0, bin-2 do begin
        ind = where((refmap ge r[i]) and (refmap lt r[i+1]))
        a = map[ind]
        ind_cov = where(a ne 0, count_cov)
        area[i] = count_cov*scale^2d
print, 'loop, ', bin-2-i
endfor
area = area[0:bin-2]

forprint, rcount, area, text="./dats/area.dat", /nocomment
END
