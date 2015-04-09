FUNCTION mask_pts, nx, ny, astrometry, scale, min, sup
;+
; NAME:
;	mask_pts
; PURPOSE:
;	Given appropriate astrometry data, create an array of masked
;	point sources
; EXPLANATION:
;	Point sources are masked out by squares of various sizes, as determined
;	by astrometry data from SExtractor.
;
; INPUTS:
;	nx - Horizontal size of the array, scaler integer
;
;       ny - Vertical size of the array, scalar integer
;
;	astrometry - File path to the SExtractor astrometry data, scalar string
;
;	scale - Determines how big masks should be. If set to 1, then the size
;	is equal to the average of elliptical axes given by astrometry data,
;	scalar double
;
;	min - minimum value of masks' width, scalar double
;	
;	sup - maximum value of masks' width, scalar double
;
; OUTPUTS:
;	A 2d array of 0, and 1, corresponding to unmasked and masked areas, 
;	respectively, array double
;
; CALLING SEQUENCE:
;	mask = mask_pts(nx, ny, astrometry, scale, min, sup)
; REVISION HISTORY:
;       Written         Masoud Rafiei-Ravandi           April, 2014
;       Email: mrafieir@uwo.ca
; LIMITATIONS:
;	- As for the astrometry, SExtractor format is assumed.
;-
;---------------------------------------------- 
readcol, astrometry, xpo, ypo, cxx, theta, elong, format='d', comment='#' 
; for some reason, cl2-end are not in dscale

; ignore highly elliptical sources
cxx[where(cxx gt 2)] = 2d
elong[where(elong gt 2)] = 2d

; initialize the array, mask
ptsmask = dblarr(nx,ny)

; loop over all point sources
for i = 0, n_elements(xpo)-1 do begin

 x = fix(xpo[i]) ; integer array index in X
 y = fix(ypo[i]) ; integer array index in Y
 c = cxx[i]
 t = theta[i]*!PI/180d
 l = elong[i]

 B = sqrt(1d/c * ((cos(t)/l)^2d + (sin(t))^2d))	; semi-minor axis
 A = B*l	; semi major axis

 r = scale*fix((A+B)/2d)	; square width
	; constarints on square width
	if r gt sup then r = sup
	if r le min then r = min
	; change pixel values by looping over indeces
	for k = 0, r do begin	; loop over pixels in X
     		for j = 0, r do begin	; loop over pixels in Y
        	xpix = x-fix(r/2d)+k
        	ypix = y-fix(r/2d)+j
		  ; make sure indeces are inside the array
		  if ( (xpix lt nx) and	(ypix lt ny) ) then begin
		  	ptsmask[xpix,ypix] = 1.
        	  endif
     		endfor
   	endfor
endfor

return, ptsmask
END
