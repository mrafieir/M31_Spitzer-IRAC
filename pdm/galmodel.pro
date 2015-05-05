dats_dir = '~/Projects/project_80032/cats/strcount_input/dats/'
readcol, dats_dir+'fscount.prt', r, f, a
scale = 1.1999d
d4 = dconv(r, scale)
mag4 = -2.5*alog10(f/a)
dmag4 = mag4*(2.5/alog(10)/sqrt(f))

readcol, '~/Projects/project_80032/cats/wedge_input/dat_prof/xn.dat', rx, fx, sfx, px
readcol, './fitpar.dat', n, R_e, mu_e, R_d,  mu_0, alpha, mu_s, a_h, $
	comment='#'
readcol, '~/Projects/project_80032/cats/wedge_input/dat_prof/yn.dat', ry, fy, sfy, py
R_s = 30d ; kpc
model_mag = dblarr(n_elements(rx), n_elements(n))
for i = 0, n_elements(n)-1 do begin
	bpar = [mu2i(mu_e[i]), R_e[i], n[i]]
	dpar = [mu2i(mu_0[i]), R_d[i]]
	hpar = [mu2i(mu_s[i]), R_s, a_h[i], alpha[i]]

	bulge = serbulge(rx, bpar)
	disk = expdisk(rx, dpar)
	halo = powhalo(rx, hpar)
	model = bulge + disk + halo

	model_mag[*, i] = i2mu(model)
endfor

@colors_kc
!p.font=-1
!p.thick=5.8
!x.thick=4.2
!y.thick=4.2
set_plot, 'ps'
device, filename="galfit.eps", encapsulated=1, xsize=40, ysize=20
cgerase & multiplot, [2,1], mxtitle='!17R !6[!17kpc!6]', $
mxtitoffset=2, mytitoffset=1, $
mytitle='!7l !6[!17mag arcsec$\up-2$!6]!17', mxtitsize=2, mytitsize=2

cgplot, rx, fx+(model_mag[27,0]-fx[27]), psym=4, color='slate gray', $
err_yhigh=sfx, err_ylow=sfx, yrange=[33,12], xrange=[0.003,60], /xlog
cgplot, ry, fy+(model_mag[7,0]-fy[7]), psym=4, $
err_yhigh=sfy, err_ylow=sfy, /overplot, color='Gold'
cgplot, d4, mag4+(model_mag[27,0]-fx[27])+16.2, psym=4, color='red', /overplot, $
err_ylow=dmag4, err_yhigh=dmag4
cgplot, rx, model_mag[*,0], /overplot, color='dark slate blue'
cgplot, rx, model_mag[*,1], /overplot, color='cornflower blue'
cgplot, rx, model_mag[*,2], /overplot, color='plum'
cgplot, rx, model_mag[*,3], /overplot, color='maroon'
cgplot, rx, i2mu(bulge), color='black', linestyle=2, /overplot
cgplot, rx, i2mu(disk), color='black', linestyle=2, /overplot
cgplot, rx, i2mu(halo), color='black', linestyle=2, /overplot

;cglegend, title=['Major (NE)','Minor (SE)'], psym=[4,4], $
;color=['yellow','cyan'], location=[3.7,12.7], vspace=2.0, $
;charsize=1.3, /data, length=0.0, /box
cgtext, 0.01, 18.5, 'Disk'
cgtext, 0.01, 22.95, 'Halo'
cgtext, 3.5, 31, 'Bulge'

multiplot
cgplot, rx, fx+(model_mag[27,0]-fx[27]), psym=4, color='slate gray', $
err_yhigh=sfx, err_ylow=sfx, yrange=[33,12], xrange=[-1.5,50]
cgplot, ry, fy+(model_mag[7,0]-fy[7]), psym=4, $
err_yhigh=sfy, err_ylow=sfy, /overplot, color='Gold'
cgplot, d4, mag4+(model_mag[27,0]-fx[27])+16.2, psym=4, color='red', /overplot, $
err_ylow=dmag4, err_yhigh=dmag4
cgplot, rx, model_mag[*,0], /overplot, color='dark slate blue'
cgplot, rx, model_mag[*,1], /overplot, color='cornflower blue'
cgplot, rx, model_mag[*,2], /overplot, color='plum'
cgplot, rx, model_mag[*,3], /overplot, color='maroon'
cgplot, rx, i2mu(bulge), color='black', linestyle=2, /overplot
cgplot, rx, i2mu(disk), color='black', linestyle=2, /overplot
cgplot, rx, i2mu(halo), color='black', linestyle=2, /overplot

cglegend, title=['NE (Wedge cut)','SE (Wedge cut)', 'Radial (Star count)'], psym=[4,4,4], $
color=['slate gray','gold', 'red'], location=[27.3,12.7], vspace=2.0, $
charsize=1.5, /data, length=0.0, /box
;cgtext, 0.01, 18.5, 'Disk'
;cgtext, 0.01, 22.95, 'Halo'
;cgtext, 3.5, 31, 'Bulge'

multiplot, /reset
device, /close

end
