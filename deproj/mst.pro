; catalog hits
ew = "~/Projects/project_80032/starcount/hit_ew.fits"
ns = "~/Projects/project_80032/starcount/hit_ns.fits"

; flux hits
;ew = "./inmaps/I1_M31.EW.big_mosaic_cov.fits"
;ns = "./inmaps/I1_M31.NS.noCRs_mosaic_cov.fits"

par_p = [1, 1, (40d - ten(37,42,54))/!radeg ]
par_dp = [1, cos(77d/!radeg), (40d - ten(37,42,54))/!radeg ]

cra = (44.33d/60+42)/60*15d
cdec = 41 + ((7.5d/60)+16)/60

center = [cra, cdec]
scale = 1.1999988d / 6d1

readcol, "~/Projects/project_80032/fbgr_cmd/CleanCat.prt", cat_ra, cat_dec, irac1, irac2, pval, format='d,d,d,d,d', comm='#'
;readcol, "./iracwise", cat_ra, cat_dec, irac1, irac2, format='d,d,d,d', comm='#'

rgc_p = galx_deproj(ew, par_p, center, scale, cat_ra, cat_dec, 1, 0)
rgc_dp = galx_deproj(ew, par_dp, center, scale, cat_ra, cat_dec, 1, 0)

;map_ew = galx_deproj(ew, par_dp, center, scale, cat_ra, cat_dec, 0, 0)
;map_ns = galx_deproj(ns, par_dp, center, scale, cat_ra, cat_dec, 0, 0)

;hit_ew = mrdfits(ew, 0, header_ew)
;hit_ns = mrdfits(ns, 0, header_ns)

;hit_ew[ where(hit_ew gt 0) ] = 1d
;hit_ew[ where(hit_ew le 0) ] = !VALUES.F_NAN

;hit_ns[ where(hit_ns gt 0) ] = 1d
;hit_ns[ where(hit_ns le 0) ] = !VALUES.F_NAN

;map_ew = map_ew * hit_ew
;map_ns = map_ns * hit_ns

;ind1 = where( (map_ew lt -0.04) or (map_ew gt 0.04) )
;ind2 = where( (map_ew gt -0.04) and (map_ew lt 0.04) ) 
;map_ew[ind1] = 0d 
;map_ew[ind2] = 1d

forprint, cat_ra, cat_dec, pval, rgc_p, rgc_dp, text='mst_output', /nocomment
;forprint, cat_ra, cat_dec, irac1, irac2, rgc_dp, text='iracwiseout', /nocomment

;fxwrite, "./inmaps/flux1.fits", header_ew, float(map_ew)
;fxwrite, "./inmaps/flux2.fits", header_ns, float(map_ns)

end
