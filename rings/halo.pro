; very basic Surface Brightness Profile
; by computing flux in annuli
;
; Functions in use: `sumann.pro', `ringprof.pro' from BUIE Library:
; '../idllib/contrib/buie/ringprof.pro'
; URL: http://www.astro.washington.edu/docs/idl/cgi-bin
; 			/getpro/library30.html?RINGPROF

; galactic centre
centre = [10750, 1500]  ; 'E-W'
;centre = [1250, 7749]  ; 'N-S'

scale = 1.1999988d ; arcsec/pix

map = mrdfits('~/Projects/project_80032/pr_maps/I1EW.fits', 0, header)
;map = mrdfits('~/Projects/project_80032/maps/I1_M31.EW.big_mosaic.fits', 0, header)
dims = size(map, /dim)

ringprof, map, centre[0], centre[1], 1000, 300, 0.0, rout, iout

end
