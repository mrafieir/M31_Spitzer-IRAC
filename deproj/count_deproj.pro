; a script to find source count profile
; as a function of the deprojected radii

map1 = mrdfits("./inmaps/catcov_rgc_ew.fits", 0, head1)
map2 = mrdfits("./inmaps/catcov_rgc_ns.fits", 0, head2)

ermode = 2
outputname = "scount_down"
;map1 = mrdfits("./inmaps/catcov_rgc_ew_p.fits", 0, head1)
;map2 = mrdfits("./inmaps/catcov_rgc_ns_p.fits", 0, head2)

readcol, "./finaloutput.prt", ra, dec, irac1, irac2, pv0, pv, rgc, drgc, format='d,d,d,d,d,d,d,d', comm='#'

;drgc = rgc

; *****************************************
scale = 1.1999988d ; arcsec/pix-side
nbox = 100d     ; total number of boxes
N = 1d        ; a constant
p = 3.1d  ; min number of pix at small radius
power = 1.1d

w = dindgen(nbox)

dw = N * p * ( power^(w/N) - 1d )  ; non-linear function of widths
w[*] = 15
dw = w

dw = total(dw, /cumul) + min(drgc)
dw = dw[0:max(where(dw lt max(drgc)))+1]

davg = dblarr(n_elements(dw)-1)
count_star = davg
pixel_area = davg

for i = 0, n_elements(dw)-2 do begin
	
	ind1 = where( (map1 ge dw[i]) AND (map1 lt dw[i+1]) , count1 )
	ind2 = where( (map2 ge dw[i]) AND (map2 lt dw[i+1]) , count2 )	
	ind_s = where( (drgc ge dw[i]) AND (drgc lt dw[i+1]) )
	
	davg[i] = (dw[i]+dw[i+1])/2d
	
	pvq = pv[ind_s]
	pv0q = pv0[ind_s]
	col = irac1[ind_s]-irac2[ind_s]

	ind_bad = where( (pv0q lt 0.5) or (col lt -0.75), complement=ind_good)
	nbad = total(pvq[ind_bad], /double) & ngood = total(pvq[ind_good], /double)
	print, nbad, ngood, sqrt(nbad)
	case ermode of
	0: count_star[i] = ngood
	1: count_star[i] = ngood+sqrt(nbad)
	2: count_star[i] = ngood-sqrt(nbad)
	endcase

	pixel_area[i] = double(count1+count2) * scale^2d
	;print, davg[i], count_star[i]	

endfor

favg = -2.5d * alog10(count_star/pixel_area)
favg_err = favg * ( 2.5d / alog(10d) / sqrt(count_star) )

forprint, davg, favg, favg_err, text=outputname, /nocomment
end
