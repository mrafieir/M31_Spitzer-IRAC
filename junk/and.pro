;maps are in fscale
map = mrdfits("~/Projects/Andromeda/maps/I1_M31.NS.noCRs_mosaic.fits", 0, header)

;cutoff = 0.52d
;par = [8d, 3d, 2d]
;astrometry = '~/Projects/Andromeda/cats/mask_data/I1nscat.dat'
;xyr = '~/Projects/Andromeda/pros/mask/ext_mask/IRAC1_NS_DS9Reg.dat'
scale = 12d
min = 6d
sup = 80d

map_size = size(map)
nx = map_size[1]
ny = map_size[2]

hits = mrdfits("~/Projects/Andromeda/maps/I1_M31.NS.noCRs_mosaic_cov.fits")
hits[where(finite(hits, /nan) or hits le 0)] = 0d
hits[where(hits gt 0)] = 1d

;ellmask = mask_ellipse(nx, ny, par, cutoff)
;fxwrite, "~/Projects/Andromeda/NEW/ellmask_I1NS.fits", header, float(ellmask)
;ellmask = 1d - mrdfits("~/Projects/Andromeda/NEW/ellmask_I1NS.fits")

;ptsmask = mask_pts(nx, ny, astrometry, scale, min, sup)
;fxwrite, "~/Projects/Andromeda/NEW/ptsmask_I1NS.fits", header, float(ptsmask)
ptsmask = 1d - mrdfits("~/Projects/Andromeda/NEW/ptsmask_I1NS.fits")

;ptsmask_ext = 1d - wrapperds9(nx, ny, xyr)
; unlike bg_ds9, bg_ds9e is 0 in [13923:14275,1480:1810]
ptsmask_ext = 1d - mrdfits("~/Projects/Andromeda/NEW/ptsmask_ext_I1NS.fits")
;fxwrite, "~/Projects/Andromeda/NEW/ptsmask_ext_I1NS.fits", header, float(ptsmask_ext)

mask = hits * (ptsmask) * (ptsmask_ext) ;* (ellmask)
bg = map*mask

fxwrite, '~/Projects/Andromeda/NEW/mask_I1NS.fits', header, float(mask)
fxwrite, '~/Projects/Andromeda/NEW/bg_I1NS.fits', header, float(bg)

END
