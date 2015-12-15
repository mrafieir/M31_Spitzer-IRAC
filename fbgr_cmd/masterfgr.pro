; fore(+)background estimation
; Keywords ==> fg: Foreground; bg: Background
; CMD system ==> [4.5] vs. [3.6]-[4.5]

; ------- input settings
;plot_set = 0 ; plot for bg galaxy counts
; flag for bg galx count analysis
;galxmode = 0
; total coverage in deg^2
ascale = 4.3420064d
ascale_w = ascale / 4d ; cat area iracXwise cmd / wise sample
ascale_t = ascale / 2.8458092d ; cat area irac cmd / tril sample
ascale_x = ascale / 10.5d ; cat area irac cmd / sdwfs
xscale = 10.5d/10d ; sdwfs / tril sdwfs
; constraints on cmd bins
xmin=-6d & xmax=6d
ymin=9d & ymax=19d
xbin = 0.4d & ybin = 0.2d ; 4, 0.34
; -------

; output file names
output_name = 'CleanCat'

; paths to input data files 
dir_fg = '~/Projects/project_80032/cats/fgr_input'
dir_bg = '~/Projects/project_80032/cats/Kim12/'

; ------------- read catalogs
; WISE fg samples, each covering 1 deg^2 area
readcol, dir_fg+"/wf3_2deg", w1_fg1, w1_fg1_sigma, w2_fg1, w2_fg1_sigma, f='d,d,d,d', comm='#'
readcol, dir_fg+"/wf4_2deg", w1_fg2, w1_fg2_sigma, w2_fg2, w2_fg2_sigma, f='d,d,d,d', comm='#'
; IRAC matched with WISE
readcol, dir_fg+"/8xWISE_cor.err_cmd", i1_x, i2_x, w1_x, w2_x, f='d,d,d,d', comm='#'
; IRAC (raw, cleaned, flags removed)
readcol, dir_fg+"/IRAC_M31_UNIQ_cor.err", ra, dec, class_star, irac1_auto, irac1, irac2_auto, irac2, f='d,d,d,d,d,d,d', comm='#'
; TRIL fg model
readcol, dir_fg+"/TRIL_M31_CONV", tw1, tw2, f='d,d', comm='#'
; sdwfs data & model
readcol, dir_fg+"/SDWFS_Ashby09", sdwfs1, sdwfs2, f='d,d', comm='#'
readcol, dir_fg+"/TRIL_SDWFS_10deg_CONV", tsdwfs1, tsdwfs2, f='d,d', comm='#'
;if galxmode then begin
; bg galaxies from Kim et al. (2012)
;readcol, dir_bg+"SDWFS_45.dat", mag_sdwfs, n_sdwfs, f='d,d'
;readcol, dir_bg+"H-ATLAS+Spitzer_45.dat", mag_hs, n_hs, f='d,d'
;readcol, dir_bg+"fazio_45.dat", mag_fls, n_fls, f='d,d'
;readcol, dir_bg+"aeges_45.dat", mag_egs, n_egs, f='d,d'
; -------------
;endif

; convert irac to wise
irac1 = irac2wise(irac1, 1, 0)
irac2 = irac2wise(irac2, 2, 0)
sdwfs1 = irac2wise(sdwfs1, 1, 0)
sdwfs2 = irac2wise(sdwfs2, 2, 0)
tsdwfs1 = irac2wise(tsdwfs1, 1, 0)
tsdwfs2 = irac2wise(tsdwfs2, 2, 0)
tw1 = irac2wise(tw1, 1, 0)
tw2 = irac2wise(tw2, 2, 0)

; ------------- initialize arrays for the following loop
x = xmin + xbin * findgen((xmax-xmin)/xbin+2) ; color
y = ymin + ybin * findgen((ymax-ymin)/ybin+2) ; mag
nox = n_elements(x)	&	noy = n_elements(y) ; # bins covering the cmd
nirac = n_elements(ra) ; total # irac sources
probcol = dblarr(nirac)	; prob values (all irac sources)
probcol[*] = 1d;!values.f_nan ; assign NAN to all elements
; -------------
step = 2
for i = 0, nox-3, step do begin ; along color axis
for j = 0, noy-2 do begin ; along mag axis
ncounts = 1d; !values.f_nan	; init the variable ncounts (assuming a scalar-formated code)
	; ------------------------------------------------
	; -------- select/count sources in cmd bins ------
	; ------------------------------------------------
	; --- IRAC (full cat)
        n_irac = squib(irac2, irac1-irac2, x[i], x[i+step], y[j], y[j+1], 0)
	ind_irac = squib(irac2, irac1-irac2, x[i], x[i+step], y[j], y[j+1], 1)
	; --- IRAC (matched w\ WISE)
	nx = squib(w2_x, w1_x-w2_x, x[i], x[i+step], y[j], y[j+1], 0)
	; --- fg samples
	nfg1 = squib(w2_fg1, w1_fg1-w2_fg1, x[i], x[i+step], y[j], y[j+1], 0)
	nfg2 = squib(w2_fg2, w1_fg2-w2_fg2, x[i], x[i+step], y[j], y[j+1], 0)
	n_wise = ascale_w * (nfg1+nfg2)/2d ; avg wise count scaled by m31 cov
	; --- fg TRIL MODEL
	n_tril = squib(tw2, tw1-tw2, x[i], x[i+step], y[j], y[j+1], 0)
	n_tril = ascale_t * n_tril ; tril count scaled by m31 cov
	; ---------------------- SDWFS -------->>>>>>>>>>>>>>>>>>>>
	n_sdwfs = squib(sdwfs2, sdwfs1-sdwfs2, x[i], x[i+step], y[j], y[j+1], 0)
	n_tsdwfs = squib(tsdwfs2, tsdwfs1-tsdwfs2, x[i], x[i+step], y[j], y[j+1], 0)	
	xdiff = ascale_x * (n_sdwfs - n_tsdwfs*xscale) ; bg galx count scaled by m31 cov
	; -------------------------------------<<<<<<<<<<<<<<<<<<<<
	
	; select stellar objects
	ind_galx = where( (irac1[ind_irac] lt irac2wise(15, 1, 0)) AND $
				(class_star[ind_irac] lt 0.05), count_galx, $
				COMPLEMENT=ind_star, NCOMPLEMENT=count_star)
	
	; compute ncounts using different catalogs
	ncounts_wise = corfg(nx, n_wise, 1)
	ncounts_tril = corfg(n_irac, n_tril, 0)
	ncounts_x = corfg(n_irac, xdiff, 0)
	
	if y[j] le irac2wise(16, 2, 0) then ncounts = ncounts_wise
	if y[j] gt irac2wise(16, 2, 0) then ncounts = ncounts_tril * ncounts_x	
	;;;;; print, '****', ncounts
	; normalize by the stellar counts
	ncounts = ncounts * n_irac / count_star	
	if ncounts gt 1 then ncounts = 1d
	if count_galx ge n_irac then ncounts = 0d
	
	;;;;; print, x[i], y[j]
	;;;;; print, count_galx, count_star, n_irac, ncounts
	;;;;; help, ind_irac
        ;;;;; print, '--------------------------------'

	if (ind_irac[0] ne -1) then begin ; any available IRAC source ?
	probcol[ind_irac] = ncounts ; apply the prob values
	endif
endfor
endfor

; convert wise to irac
irac1 = irac2wise(irac1, 1, 1)
irac2 = irac2wise(irac2, 2, 1)
sdwfs1 = irac2wise(sdwfs1, 1, 1)
sdwfs2 = irac2wise(sdwfs2, 2, 1)
tsdwfs1 = irac2wise(tsdwfs1, 1, 1)
tsdwfs2 = irac2wise(tsdwfs2, 2, 1)
tw1 = irac2wise(tw1, 1, 1)
tw2 = irac2wise(tw2, 2, 1)

; select stellar objects
ind_galx = where( (irac1 lt 15) AND $
		(class_star lt 0.05), count_galx, $
		COMPLEMENT=ind_star, NCOMPLEMENT=count_star)
forprint, ra[ind_star], dec[ind_star], irac1[ind_star], $
	irac2[ind_star], probcol[ind_star], text=output_name, /nocomment

; bgkim.pro
END
