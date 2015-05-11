; make a .fits master hit map based on two
; given hit maps each with partial coverage.
; ---- requires: nanz.pro, fxwrite.pro
function hitmaker, map1, map2, header, path_out

; replace NANs with 0
map1 = nanz(map1)
map2 = nanz(map2)

; make sure maps have the same dimensions
dim1 = size(map1)
dim2 = size(map2)

if (dim1[1] eq dim2[1]) and (dim1[2] eq dim2[2]) then begin
	; replace all good hits with 1
	map1[where(map1 ne 0)] = 1d
	map2[where(map2 ne 0)] = 1d
	; multiply the two maps and save as .fits
	fxwrite, path_out, header, float(map1*map2)	
	return, 1 ; everything was fine
endif else return, -1 ; dimensions are not the same
END
