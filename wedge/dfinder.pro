; given a vector of box widths, find distance
; from the given centre

function dfinder, w, centre

n = n_elements(w)
d = dblarr(n)

d[0] = centre

for i = 1, n-1 do begin
	d[i] = ( centre + w[0]/2d + total(w[1:i]) - w[i]/2d )
endfor

return, d

end
