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




; load the catalog and convert ra/dec to x/y
;readcol, '~/Projects/project_80032/cats/strcount_input/dats/finalcmd', ra, dec, i2, color, i1, prob
;adxy, header_ew, ra, dec, x_ew, y_ew
;adxy, header_ns, ra, dec, x_ns, y_ns
; convert x/y to integers for index manipulations
;x_ew = fix(x_ew) & y_ew = fix(y_ew)
;x_ns = fix(x_ns) & y_ns = fix(y_ns)

; find the total coverage by the catalog over the maps --->>>>>>>>>>>>>
;lx = fix(max(x_ew<8e3))
;rx = fix(min(x_ew>1.35e4))

;ly = fix(minmax(y_ew[where(x_ew<8e3)]>0))
;ry = fix(minmax(y_ew[where(x_ew>1.35e4)]>0))

;map_ew[lx:rx,*] = 0d ; between left and right wings

;map_ew[0:lx,*] = 0d ; left wing
;map_ew[0:lx,ly[1]:*] = 0d ; left wing

;map_ew[rx:*,*] = 0d ; right wing
;map_ew[rx:*,ry[1]:*] = 0d ; right wing

;uy = min(y_ns>7750) ; up wing
;dy = max(y_ns<7750) ; down wing

;map_ns[*,dy:uy] = 0d ; between up and down wings
; -------------------<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; write new hit maps
fxwrite, '~/Projects/project_80032/maps/hit_ew.fits', header_ew, float(map_ew)
fxwrite, '~/Projects/project_80032/maps/hit_ns.fits', header_ns, float(map_ns)

END
