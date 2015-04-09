; very basic Surface Brightness Profile
; by computing flux in annuli

; galactic centre

centre = [10750, 1500]  ; 'E-W'
;centre = [1250, 7749]  ; 'N-S'

scale = 1.1999988d ; arcsec/pix

map = mrdfits('~/Projects/Andromeda/pr_maps/I1EW.fits', 0, header)
;map = mrdfits('/Users/mrafieir/Projects/Andromeda/maps/I1_M31.EW.big_mosaic.fits', 0, header)
dims = size(map, /dim)

ringprof, map, centre[0], centre[1], 1000, 300, 0.0, rout, iout

end
