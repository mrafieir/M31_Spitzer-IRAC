; a script to (median-flux-based) SB profile
; as a function of (de)projected distance.
; +
; *****************************

deproj = 1
dvar = 1
bgmode = 0

outputname = "flx"

;map1 = mrdfits("./inmaps/I1EW.fits", 0, head1)
;map2 = mrdfits("./inmaps/I1NS.fits", 0, head2)
;mapbg1 = mrdfits("./inmaps/ewbg.fits", 0, headbg1)
;mapbg2 = mrdfits("./inmaps/nsbg.fits", 0, headbg2)


map1 = mrdfits("~/Projects/project_80032/NEW/45maps/I1EW_final_smooth.fits", 0, head1)
map2 = mrdfits("~/Projects/project_80032/NEW/45maps/I1NS_final_smooth.fits", 0, head2)
mapbg1 = mrdfits("~/Projects/project_80032/NEW/45maps/I1EW_background_smooth.fits", 0, headbg1)
mapbg2 = mrdfits("~/Projects/project_80032/NEW/45maps/I1NS_background_smooth.fits", 0, headbg2)


;map1 = mrdfits("./inmaps/I1_M31.EW.big_mosaic.fits", 0, head1)
;map2 = mrdfits("./inmaps/I1_M31.NS.noCRs_mosaic.fits", 0, head2)

map2[828:1508,9192:10113] = !values.f_nan
mapbg2[828:1508,9192:10113] = !values.f_nan

scale = 1.1999988d ; arcsec/pix-side
ch = 1  ; IRAC band ID
level = 3       ; cut level for flx measurement
boot = 100       ; # bootstraping loop

apcor = 0.91d
aplim = 5d

; *****************************
case deproj of
0: begin
	rmap1 = mrdfits("./inmaps/flux1p.fits", 0)
	rmap2 = mrdfits("./inmaps/flux2p.fits", 0)
	outputname = "flxp"
end
1: begin
	rmap1 = mrdfits("./inmaps/flux1.fits", 0)
        rmap2 = mrdfits("./inmaps/flux2.fits", 0)
;	outputname = "flx"
end
endcase

case dvar of	
0: begin
	nbox = 700
	w = 1.5
	dw = replicate(w, nbox) 
end
1: begin
	nbox = 200d     ; total number of boxes
	N = 1d        ; a constant
	p = 5.25d  ; min number of pix at small radius
	power = 1.01d	; base of exp
	w = dindgen(nbox)
	dw = N * p * ( power^(w/N) - 1d )  ; non-linear function of widths
end 
endcase

dw = total(dw, /cumul)
dw = dw[0:max(where(dw lt max(rmap2, /nan)))+1]

davg = dblarr(n_elements(dw)-1)
flx = davg
flx_err = davg

for i = 0, 55 do begin;n_elements(dw)-2 do begin

	davg[i] = (dw[i]+dw[i+1])/2d
 
        ind1 = where( (rmap1 ge dw[i]) AND (rmap1 lt dw[i+1]), count1 )
        ind2 = where( (rmap2 ge dw[i]) AND (rmap2 lt dw[i+1]), count2 )  
        
	s = [ map1[ind1], map2[ind2] ]

	; background
	sbg = [ mapbg1[ind1], mapbg2[ind2] ]
	sigmabg = bootstrap_median2(sbg, n_iter=boot)
	case bgmode of
	0: s = s
	1: s = s - sigmabg[0] - sigmabg[1]
	2: s = s - sigmabg[0] + sigmabg[1]
	endcase
	; ----------

	sigma = bootstrap_median2(s, n_iter=boot)
	flx_s = sigma[0]
	sigma = sigma[1]
	b_ind = where(s lt flx_s+level*sigma)
	sigma = bootstrap_median2(s[b_ind], n_iter=boot)	
	
	if davg[i] ge aplim then begin
		flx[i] = apcor * sigma[0]
		flx_err[i] = sqrt((sigma[1]/sigma[0])^2d + 0.1^2d) * flx[i]
	endif else begin
		flx[i] = sigma[0]
		flx_err[i] = sigma[1]
	endelse
	
	print, n_elements(dw)-2-i, davg[i], flx[i], flx_err[i]

endfor

mag = flxconv(flx, scale, ch)
mag_err = 2.5 * alog10( flx_err/flx + 1 )

;forprint, davg, mag, mag_err, text=outputname, /nocomment
end
