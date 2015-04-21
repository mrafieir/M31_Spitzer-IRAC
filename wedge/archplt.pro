function archplt, r, mag, umag_err, lmag_err, r1, mag1, umag_err1, $
lmag_err1, r2, mag2, mag_err2, r3, mag3, mag_err3, d4, mag4, id, _extra=ex

ind = where(finite(mag))
r = r[ind] & mag = mag[ind] & umag_err = umag_err[ind] & lmag_err = lmag_err[ind]

ind1 = where(finite(mag1))
r1 = r1[ind1] & mag1 = mag1[ind1] & umag_err1 = umag_err1[ind1] & lmag_err1 = lmag_err1[ind1]

;print, '--->', n_elements(ind), ' data points are selected...'

@colors_kc
!p.font=-1
!p.thick=3.8
!x.thick=2.8
!y.thick=2.8

set_plot, 'ps'
device, filename="sfp_"+id+".eps", encapsulated=1, xsize=16, ysize=10.2
cgerase & multiplot, [2,2], /square, mxtitle='!17R !6[!17kpc!6]', $
;mxtitoffset=-0.9, mytitoffset=0.2, $
mytitle='!7l !6[!17mag arcsec$\up-2$!6]!17';, mxtitsize=1.5, mytitsize=1.5

cgplot, r, mag, err_ylow=lmag_err, err_yhigh=umag_err, psym=4, $
symsize=0.5, color='blue', xrange=[2e-3,4.6e1], yrange=[30,10], $
/xlog;, xtickformat='(e3.2)'

cgplot, r1, mag1, err_ylow=lmag_err1, err_yhigh=umag_err1, $
psym=4, symsize=0.5, color='green', /overplot

;cgplot, r2, mag2, psym=4, symsize=0.5, color='red', /overplot, $
;err_ylow=lmag_err2, err_yhigh=umag_err2

;cgplot, r3, mag3, psym=4, symsize=0.5, color='green', /overplot, $
;err_ylow=lmag_err2, err_yhigh=umag_err2
cgplot, d4, mag4+16.2, psym=4, symsize=0.5, color='cyan', /overplot
multiplot

cgplot, r, mag, err_ylow=lmag_err, err_yhigh=umag_err, psym=4, $
symsize=0.5, color='blue', xrange=[0,46], yrange=[30,10]

cgplot, r1, mag1, err_ylow=lmag_err1, err_yhigh=umag_err1, $
psym=4, symsize=0.5, color='green', /overplot

;cgplot, r2, mag2, psym=4, symsize=0.5, color='red', /overplot, $
;err_ylow=lmag_err2, err_yhigh=umag_err2

;cgplot, r3, mag3, psym=4, symsize=0.5, color='green', /overplot, $
;err_ylow=lmag_err2, err_yhigh=umag_err2
cgplot, d4, mag4+16.2, psym=4, symsize=0.5, color='cyan', /overplot
multiplot

multiplot, /reset
device, /close

return, 1
end
