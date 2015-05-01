function trilgen, i1, i1s, t1

half_step = 0.1

r1 = dblarr(n_elements(t1))
for j = 0, n_elements(t1)-1 do begin 
        ind = where( (i1 le t1[j]+half_step) AND (i1 ge t1[j]-half_step), count )
	if count ge 1 then begin
        sigma = mean(i1s[ind])
        r = randomn(seed, 1)
        r1[j] = r * sigma + t1[j]
	endif else r1[j] = t1[j]
        print, t1[j], r1[j]
endfor

return, r1

END
