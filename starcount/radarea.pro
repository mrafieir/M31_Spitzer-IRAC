; compute area in radial bins
scale = 1.1999988d ; arcsec/pixel
cra = 10.6833d
cdec = 41.2689d
bin = 16 & dr = 475 & mincut=3000

map = mrdfits('./hit_ns.fits', 0, header)
dims = fix(size(map, /dim))

; initiating the centre
adxy, header, cra, cdec, cx, cy
cx = fix(cx) & cy = fix(cy)

; making a ref map for radial dist
refmap = dist(dims[0], dims[1])
refmap = shift(refmap, cx, cy)
;fxwrite, "./refmap_ns.fits", header, float(refmap)
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

forprint, rcount, area, text="area_ns", /nocomment
END
