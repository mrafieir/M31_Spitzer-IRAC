FUNCTION scount, file
; +
;   NAME: scount
;	    
;   PURPOSE: Convert distance from degrees to kpc on the sky
;
;   INPUTS:
;	   FilePath = String path to an ASCII file containing distance values
;		      in the first column
;   OUTPUTS:
;	   Angular diameter distance in kpc
;
;   LIMITATIONS:
;	   The current version only works for M31. This can be modified
;	   using the first few lines of the code.
;
; © Masoud Rafiei Ravandi
; Email:	mrafiei.ravandi@gmail.com
;-
;-----------------
readcol, file, dfc, comment='#', format='d'

; for M31
d = 788d ; kpc
z = 0.00100d ; redshift
d_a = d / (1d + z) ; angular diameter distance

conv = !pi/180d ; convert deg to radian

return, dfc * conv * d_a

END
