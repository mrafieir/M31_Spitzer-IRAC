; a script to find the net area covered
; by the IRAC catalog over the major- 
; and minor axis.\

; code is written by,
;	Masoud Rafiei Ravandi <mrafiei.ravandi@gmail.com>
; in the Interactive Programming Language (IDL)
; © 2015

; load maps
map_ew = mrdfits('~/Projects/project_80032/maps/masterhit_EW.fits', 0, header_ew)
map_ns = mrdfits('~/Projects/project_80032/maps/masterhit_NS.fits', 0, header_ns)

; ------------- >>>>>>>> East - West
readcol, '~/Dropbox/left', ra, dec	; left wing
adxy, header_ew, ra, dec, lx, ly
; find end points
lx = fix(minmax(lx))
ly = fix(minmax(ly))
; ---
readcol, '~/Dropbox/right', ra, dec	; right wing
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
fxwrite, '~/Projects/project_80032/maps/hit_ew.fits', header_ew, float(map_ew)

; ------------- >>>>>>>> North - South
readcol, '~/Dropbox/up', ra, dec
adxy, header_ns, ra, dec, ux, uy
; find end points
ux = fix(minmax(ux))
uy = fix(minmax(uy))
; ---
readcol, '~/Dropbox/down', ra, dec
adxy, header_ns, ra, dec, dx, dy
dx = fix(minmax(dx))
dy = fix(minmax(dy))
; set bad pix to zeros
map_ns[*, dy[1]:uy[0]] = 0d
; write the new NS map
fxwrite, '~/Projects/project_80032/maps/hit_ns.fits', header_ns, float(map_ns)
END
