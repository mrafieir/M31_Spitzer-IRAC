; a script to find the net area covered
; by the IRAC catalog over the major- 
; and minor axis.\

; code is written by,
;	Masoud Rafiei Ravandi <mrafiei.ravandi@gmail.com>

scale = 1.1999988d ; "/pix-side
scale = (scale/3600)^2d ; sq. deg. / pix

; load maps
map_ew = mrdfits('~/Projects/project_80032/cats/masterhit_EW.fits', 0, header_ew)
map_ns = mrdfits('~/Projects/project_80032/cats/masterhit_NS.fits', 0, header_ns)

; ------------- >>>>>>>> East - West
readcol, './left', ra, dec, comm='#'	; left wing
adxy, header_ew, ra, dec, lx, ly
; find end points
lx = fix(minmax(lx))
ly = fix(minmax(ly))
; ---
readcol, './right', ra, dec, comm='#'	; right wing
adxy, header_ew, ra, dec, rx, ry
rx = fix(minmax(rx))
ry = fix(minmax(ry))
; set bad pixs to zeros
map_ew[lx[1]:rx[0], *] = 0d
map_ew[lx[0]:lx[1], 0:ly[0]] = 0d
map_ew[lx[0]:lx[1], ly[1]:*] = 0d
map_ew[rx[0]:rx[1], 0:ry[0]] = 0d
map_ew[rx[0]:rx[1], ry[1]:*] = 0d
; write the new EW map
fxwrite, './hit_ew.fits', header_ew, float(map_ew)

; ------------- >>>>>>>> North - South
readcol, './up', ra, dec, comm='#'
adxy, header_ns, ra, dec, ux, uy
; find end points
ux = fix(minmax(ux))
uy = fix(minmax(uy))
; ---
readcol, './down', ra, dec, comm='#'
adxy, header_ns, ra, dec, dx, dy
dx = fix(minmax(dx))
dy = fix(minmax(dy))
; set bad pix to zeros
map_ns[*, dy[1]:uy[0]] = 0d
; write the new NS map
fxwrite, './hit_ns.fits', header_ns, float(map_ns)
n1 = where(map_ew eq 1, count1)
n2 = where(map_ns eq 1, count2)
print, 'total area = ', '', (count1+count2)*scale, 'sq. deg'
END
