readcol, '~/Projects/Andromeda/pros/wedge/dat_prof/yn.dat', r, f, sf, p
readcol, './fitpar.dat', n, R_e, mu_e, R_d,  mu_0, alpha, mu_s, a_h, $
	comment='#'
R_s = 30d ; kpc
model_mag = dblarr(n_elements(r), n_elements(n))
for i = 0, n_elements(n)-1 do begin
	bpar = [mu2i(mu_e[i]), R_e[i], n[i]]
	dpar = [mu2i(mu_0[i]), R_d[i]]
	hpar = [mu2i(mu_s[i]), R_s, a_h[i], alpha[i]]

	bulge = serbulge(r, bpar)
	disk = expdisk(r, dpar)
	halo = powhalo(r, hpar)
	model = bulge + disk + halo

	model_mag[*, i] = i2mu(model)
endfor

plot, r, model_mag[*,0], yrange=[33,10], xrange=[1e-3,1e2], /xlog
for i = 1, 3 do begin
	oplot, r, model_mag[*,i]
endfor

end
