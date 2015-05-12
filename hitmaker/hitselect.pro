; a script to find the total coverage by the selected 
; catalog of IRAC sources, which cover the uncrowded 
; (outer) regions <--- used for cmd analysis in /fbgr_cmd

scale = 1.1999988 ; arcsec/pixel-side
; load maps
mapEW = mrdfits("~/Projects/project_80032/pr_maps/hits/masterhit_EW.fits", 0, $
headerEW)
mapNS = mrdfits("~/Projects/project_80032/pr_maps/hits/masterhit_NS.fits", 0, $
headerNS)

; select good (i.e. hit = 1) indexes
hitexEW = where( (mapEW[0:4985,*] eq 1) OR (mapEW[15709:*,*] eq 1) , countEW)
hitexNS = where( (mapNS[*,0:6057] eq 1) OR (mapNS[*,10518:*] eq 1) , countNS)

; total (good) pixel counts
cov = countEW + countNS

; convert to sq. deg
fact = (scale/3600d)^2d ; pixel area in sq. deg
covd = cov * fact ; conversion

; print results
print, countEW, countNS, ' ----> TOTAL = ', cov
print, 'coverage in sq. deg = ', covd

END
