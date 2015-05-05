; a script to find the total coverage of the IRAC catalog based on 
; a `hit' mosaic that covers a larger area. MIN and MAX pixel coords 
; of (each wing in) the catalog are used to constrain the covered area
; (by the catalog) in the mosaic.

scale = 1.1999988 ; arcsec/pixel-side

; up-down hit map (i.e. along major axis)
hits_ud = mrdfits("~/Projects/project_80032/maps/I1_M31.NS.noCRs_mosaic_cov.fits", 0, header)
; replace all bad hits with 0
nans_ind = where(finite(hits_ud, /nan) or hits_ud le 0)
hits_ud[nans_ind] = 0d

; left-right hit map (i.e. along minor axis)
hits_lr = mrdfits("~/Projects/project_80032/maps/I1_M31.EW.big_mosaic_cov.fits")
; replace all bad hits with 0
nans_ind = where(finite(hits_lr, /nan) or hits_lr le 0)
hits_lr[nans_ind] = 0d

; read catalogs (selected from the full catalog using TOPCAT)
up = mrdfits("~/Projects/project_80032/cats/iracfits_u", 1) 
down = mrdfits("~/Projects/project_80032/cats/iracfits_d", 1)
left = mrdfits("~/Projects/project_80032/cats/iracfits_l", 1)
right = mrdfits("~/Projects/project_80032/cats/iracfits_r", 1)

; sources in the up wing have wrong x & y coordinats
; so we use RA & DEC instead
rau = up.col38
decu = up.col39
; convert to correct x & y coordinates
adxy, header, rau, decu, xu, yu 
xu = fix(xu) & yu = fix(yu)

; select all pixels that have a non-zero hit
ind  = where(hits_ud[*,min(yu):*] gt 0d, nu)	; nu = total # pixel count

; do the same for down, left, and right wings
xd = fix(down.col36)
yd = fix(down.col37)
ind = where(hits_ud[*,0:max(yd)] gt 0d, nd)

xl = fix(left.col36)
yl = fix(left.col37)
indl = where(hits_lr[0:max(xl),*] gt 0d, nl)

xr = fix(right.col36)
yr = fix(right.col37)
indr = where(hits_lr[min(xr):*,*] gt 0d, nr)

; a new scale factor in (deg/pixel-side)^2
fact = (scale/3600d)^2d

; total coverage for each wing (in deg^2)
print, 'up', nu*fact
print, 'down', nd*fact
print, 'left', nl*fact
print, 'right', nr*fact

; add all to get the total coverage over the full observation
n = nu + nd + nl + nr
n = n * fact ; deg^2
print, 'total area in deg^2= ', n	; 3.8423337 deg^2

end
