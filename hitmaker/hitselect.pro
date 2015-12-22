; a script to find the total coverage by the selected 
; catalog of IRAC sources, which cover the uncrowded 
; (outer) regions <--- used for cmd analysis in /fbgr_cmd

scale = 1.1999988 ; arcsec/pixel-side
; load maps
mapEW = mrdfits("~/Projects/project_80032/cats/masterhit_EW.fits", 0, $
headerEW)
mapNS = mrdfits("~/Projects/project_80032/cats/masterhit_NS.fits", 0, $
headerNS)

; select good (i.e. hit = 1) indexes
; for full cat:

; makenew hits based on catalog
new = mapEW
new[*] = 0d
new[0:7789,603:2755] = mapEW[0:7789,603:2755]
new[13799:*,603:*] = mapEW[13799:*,603:*]
fxwrite, "~/Projects/project_80032/hitmaker/new.fits", headerEW, float(new)

nns = mapNS
nns[*] = 0d
nns[*,0:7489] = mapNS[*,0:7489]
nns[*,8083:*] = mapNS[*,8083:*]
fxwrite, "~/Projects/project_80032/hitmaker/nns.fits", headerNS, float(nns)

t1 = where(new eq 1, t1n)
t2 = where(nns eq 1, t2n)
tn = t1n + t2n

; convert to sq. deg
fact = (scale/3600d)^2d ; pixel area in sq. deg
covt = tn * fact ; conversion

; print results
print, t2n, t1n, ' ----> TOTAL = ', tn
print, 'coverage in sq. deg = ', covt

END
