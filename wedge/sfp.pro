TIC
mode = 1
orient = 0
ch = 1
; Surface Brightness Profile
; by wedging along galactic axes

; galactic centre
case mode of
0: centre = [10750, 1500]	; 'E-W'
1: centre = [1250, 7749]	; 'N-S'
endcase

scale = 1.1999988d ; arcsec/pix

level = 3	; confidence level above the median to be rejected
boot = 10	; # bootstraping sample
nbox = 200d 	; total number of boxes
N = 500d	; a constant
p = 1d	; min number of pix at small radius


case mode of
0: map = mrdfits('../pr_maps/I1EW.fits', 0, header)
1: map = mrdfits('../pr_maps/I1NS.fits', 0, header)
;0: map = mrdfits('../maps/I1_M31.EW.big_mosaic.fits', 0, header)
;1: map = mrdfits('../maps/I1_M31.NS.noCRs_mosaic.fits', 0, header)
endcase

dims = size(map, /dim)

; masking peaks and misc
if mode eq 1 then begin
readcol, '../pr_maps/I1NS_mask.dat', xi, xf, yi, yf, comment='#'
map[xi:xf,yi:yf] = !values.f_nan
endif

if (orient eq 1) then begin
map = rotate(map, 2) & centre = dims - centre
endif

x = findgen(nbox) + 1d
w = N * p * ( 1.8^(x/N) - 1d )	; non-linear function of widths

; adding up all widths, to make sure they fall inside the map
for i = 0, nbox-1 do begin
	t = total(w[0:i], /double)
	if t lt (dims[0]-centre[0]) then Wx = w[0:i]
	if t lt (dims[1]-centre[1]) then Wy = w[0:i]
endfor

; find distance from the zeroth pix to the centre 
; of each box along both axes
dx = dfinder(Wx, centre[0])
dy = dfinder(Wy, centre[1])

; find the median flux & its error in boxes
xflux = flxmeasure(map, centre[1], Wx, dx, level, 0, boot, scale)
yflux = flxmeasure(map, centre[0], Wy, dy, level, 1, boot, scale)

; find the radial distance in kpc
rx = dconv(dx-centre[0], scale)
ry = dconv(dy-centre[1], scale)

; convert flux to mag/arcsec^2
xmag = flxconv(xflux[*,0], scale, ch)
ymag = flxconv(yflux[*,0], scale, ch)

; find error values in magnitude unit
uxmag_err = abs(-2.5d*alog10(xflux[*,1]))
uymag_err = abs(-2.5d*alog10(yflux[*,1]))

lxmag_err = abs(-2.5d*alog10(xflux[*,2]))
lymag_err = abs(-2.5d*alog10(yflux[*,2]))

case orient of
0: begin 
	xname="x.dat" 
	yname="y.dat"
   end
1: begin
	xname="xn.dat"
	yname='yn.dat'
   end
endcase

case mode of
0: forprint, rx, xmag, uxmag_err, lxmag_err, text=xname, /nocomment
1: forprint, ry, ymag, uymag_err, lymag_err, text=yname, /nocomment
endcase
TOC
end
