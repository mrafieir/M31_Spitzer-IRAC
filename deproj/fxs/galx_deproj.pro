FUNCTION galx_deproj, path, par, center, scale, cat_ra, cat_dec, mode, angl
map = mrdfits(path, 0, header)
adxy, header, center[0], center[1], h, k

case mode of
0: begin 
	dimen = size(map, /dim)
	x = findgen(dimen[0]) # replicate(1.0, dimen[1])
	y = replicate(1.0, dimen[0]) # findgen(dimen[1])
   end
1: begin
	adxy, header, cat_ra, cat_dec, x, y
   end
endcase
	
aaxis = par[0]
baxis = par[1]
tilt = par[2]

xprime = (x-h)*cos(tilt) - (y-k)*sin(tilt)
yprime = (x-h)*sin(tilt) + (y-k)*cos(tilt)

if angl eq 1 then begin
U = atan( yprime / xprime )
endif else begin
U = sqrt( (xprime/aaxis)^2d + (yprime/baxis)^2d )
U = U * scale
endelse

return, U
;mkhdr, header, u
;fxwrite, './test.fits', header, double(u*par[0])
END
