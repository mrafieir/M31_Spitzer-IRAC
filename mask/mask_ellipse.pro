FUNCTION mask_ellipse, nx, ny, par, cutoff
;+
; NAME:
;	mask_ellipse
; PURPOSE:
;	Create a 2d array containing an elliptical mask at its centre
; EXPLANATION:
;	An elliptical mask (i.e. 0 and 1) is created by slicing a 3d 
;	ellipsoidal surface.
;
; INPUTS:
;	nx - Horizontal size of the array, scaler integer
;
;	ny - Vertical size of the array, scalar integer
;
;	par - [xscale, yscale, tilt], 3-element vector double
;		-	xscale: Semi-major scale factor
;		-	yscale: Semi-minor scale factor
;		-	tilt: Measured in degrees, orientation of the 
;			ellipse wrt x axis
;
;	cutoff - Cutoff value (between 0 and 1) determines the size of the 
;	ellipse. Smaller cutoff results in a bigger mask, scalar double
;
; OUTPUTS:
;	A 2d array of 0 and 1, corresponding to an elliptical mask, array double
;
; CALLING SEQUENCE:
;	mask = mask_ellipse(nx, ny, par, cutoff)
; REVISION HISTORY:
;	*******************************************************************
;	This code is based on an example provided by Exelis VIS Docs Center
;	webpage: http://www.exelisvis.com/docs/GAUSS2DFIT.html
;	*******************************************************************
;
;	Written		Masoud Rafiei-Ravandi		April, 2014
;	Email: mrafieir@uwo.ca
;-
;----------------------------------------------
x = findgen(nx) # replicate(1.0, ny)
y = replicate(1.0, nx) # findgen(ny)

; rescale major & minor axes
aaxis = nx/par[0]
baxis = ny/par[1]

h = 0.5d*nx ; Xcentered
k = 0.5d*ny ; Ycentered
tilt = par[2]*!PI/180d ; radian

; vector of parameters: [offset, amplitude, majorA, minorA, xCent, yCent, tilt(wrt)Xaxis]
A = [0d , 1d, aaxis, baxis, h, k, tilt]

; make the 3D ellipsoidal surface
xprime = (x-h)*cos(tilt) - (y-k)*sin(tilt)
yprime = (x-h)*sin(tilt) + (y-k)*cos(tilt)
U = (xprime/aaxis)^2d + (yprime/baxis)^2d
ellmask = A[0] + A[1] * exp(-U/2d)

; project the surface into a 2D mask, i.e. zeros and ones
pix = where(ellmask lt cutoff)
ellmask[pix] = 0d	; masked
pixs = where(ellmask ne 0d)
ellmask[pixs] = 1d	; not masked

return, ellmask
END
