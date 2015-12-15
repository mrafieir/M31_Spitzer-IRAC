readcol, "./flx.prt", r, f, sf, format='d,d,d'
readcol, "./flx_up.prt", r, f_up, sf_up, format='d,d,d'
readcol, "./flx_down.prt", r, f_down, sf_down, format='d,d,d'

z = dblarr(n_elements(f))
for i = 0, n_elements(f)-1 do begin
	z_up = abs(f[i]-f_up[i])
	z_down = abs(f[i]-f_down[i])
	z[i] = max([z_up, z_down])
	if (z[i] gt 0) AND (r[i] lt 65) then begin
	z[i] = sqrt(z[i]^2d + sf[i]^2d)
	endif else z[i] = 0d
endfor
ind = where(r lt 86)
forprint, r[ind], f[ind], z[ind], text="flx_final", /nocomment

; ----- star count
readcol, "./scount.prt", r, f, sf, format='d,d,d'
readcol, "./scount_up.prt", r, f_up, sf_up, format='d,d,d'
readcol, "./scount_down.prt", r, f_down, sf_down, format='d,d,d'

z = dblarr(n_elements(f))
for i = 0, n_elements(f)-1 do begin
	z_up = abs(f[i]-f_up[i])
	z_down = abs(f[i]-f_down[i])
	z[i] = max([z_up, z_down])
	z[i] = sqrt(z[i]^2d + sf[i]^2d)
endfor
ind = where((r lt 200) and (r gt 90))
r = r[ind] & f = f[ind] & z = z[ind]
f = f - f[0] + 26d
forprint, r, f, z, text="scount_final", /nocomment
end
