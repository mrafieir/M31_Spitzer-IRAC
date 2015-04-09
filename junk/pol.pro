; naive version of the polynomial fitting procedure
; This code has been superseded by 'fitcript.pro'

;------- naive examples --------
;*******************************	
;	bg = dist(nx,ny)
;	bg = sin(bg/1000)
;*******************************
;-------------------------------

;-------------------------------
;----- Polyfit to 'columns' ----
;-------------------------------

bgx = dblarr(nx,ny)
y = findgen(ny)
nan = where(finite(bg, /nan))
bg[nan] = 0

rx = 0.
for h = 0, nx-1 do begin
	
	xmask = y
	xmask[*] = mask[h,*]
	good = where(xmask eq 1.)
	sgood = size(good)
	sgood = sgood[0]
	
	if sgood then begin
	xbg = y
	xbg[*] = map[h,*] ; 'map' could be replaced with 'bg (=map*mask)'
	
	c = poly_fit(y[good], xbg[good], 3)
	bgx[h,*] = c[3]*y^3d + c[2]*y^2d + c[1]*y + c[0]
	
	endif else begin
	bgx[h,*] = 0.
	rx = rx + (h+1)/(h+1)
	endelse
print, nx-1-h
endfor

;-------------------------------
;----- Polyfit to 'rows' -------
;-------------------------------

bgy = dblarr(nx,ny)
x = findgen(nx)

ry = 0.
for h = 0, ny-1 do begin

        ymask = x
        ymask[*] = mask[*,h]
        good = where(ymask eq 1.)
        sgood = size(good)
        sgood = sgood[0]

        if sgood then begin
        ybg = x
        ybg[*] = map[*,h]

        c = poly_fit(x[good], ybg[good], 3)
        bgy[*,h] = c[3]*x^3d + c[2]*x^2d + c[1]*x + c[0]

;c = poly_fit(x[good], ybg[good], 4)
;bgy[*,h] = c[4]*x^4 + c[3]*x^3 + c[2]*x^2 + c[1]*x + c[0]

        endif else begin
        bgy[*,h] = 0.
        ry = ry + (h+1)/(h+1)
        endelse
print, ny-1-h
endfor

finalx = (map - bgx) * hits ;columns
finaly = (map - bgy) * hits ;rows
final = (map - (bgx+bgy)/2d) * hits ;avg

fxwrite, "~/Projects/Andromeda/finalx4.fits", header, float(finalx)
fxwrite, "~/Projects/Andromeda/finaly4.fits", header, float(finaly)
fxwrite, "~/Projects/Andromeda/final4.fits", header, float(final)

end
