; the core conditional in masterfg.pro

function corfg, ncase, n_avg, xkey

ndiff = ncase - n_avg

if (ncase gt 0) AND (n_avg ge 0) then begin      ; any pts?
	if (ndiff gt 0) then begin      ; total>fg
		ncounts = ndiff / ncase
	endif else ncounts = 0d ; S/N <= 1
endif else ncounts = 1d

if ncase le 0 and n_avg gt 0 then ncounts = 0d
if xkey eq 1 and ncase lt 0 and n_avg lt 0 then ncounts = 1d

if ncase lt 0 and n_avg eq 0 then begin
	if xkey eq 1 then ncounts = 1d
	if xkey eq 0 then ncounts = 0d
endif
if xkey eq 0 and ncase lt 0 and n_avg lt 0 then ncounts = 0d

;print, 'corfg', xkey, ncase, n_avg, ncounts
return, ncounts
end
