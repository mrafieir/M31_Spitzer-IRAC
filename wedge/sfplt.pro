readcol, './dat_prof/x.dat', rx, xmag, uxmag_err, lxmag_err
readcol, './dat_prof/xn.dat', rx1, xmag1, uxmag_err1, lxmag_err1
readcol, './dat_prof/m31_irac1_mincutmag.prof', rx2, xmag2, xmag_err2
readcol, './dat_prof/m31_irac1_avgmag.prof', rx3, xmag3, xmag_err3

;rx2 = dconv(rx2, 1d)
rx3 = dconv(rx3, 1d)
rx2 = dconv(rx2, 1d)

readcol, './dat_prof/y.dat', ry, ymag, uymag_err, lymag_err
readcol, './dat_prof/yn.dat', ry1, ymag1, uymag_err1, lymag_err1
readcol, './dat_prof/m31_irac1_avgmag.prof', ry2, ymag2, ymag_err2
readcol, './dat_prof/m31_irac1_mincutmag.prof', ry3, ymag3, ymag_err3

ry3 = dconv(ry3, 1d)
ry2 = dconv(ry2, 1d)

dats_dir = '../cats/strcount_input/dats/'
scale = 1.1999d

readcol, dats_dir+'fscount.prt', r, f, a
d4 = dconv(r, scale)
mag4 = -2.5*alog10(f/a)
dmag4 = mag4*(2.5/alog(10)/sqrt(f))

readcol, dats_dir+'p14-15.dat', r2, f2, a2
d42 = dconv(r2, scale)
mag42 = -2.5*alog10(f2/a2)
dmag42 = mag42*(2.5/alog(10)/sqrt(f2))

readcol, dats_dir+'p15-16.dat', r3, f3, a3
d43 = dconv(r3, scale)
mag43 = -2.5*alog10(f3/a3)
dmag43 = mag43*(2.5/alog(10)/sqrt(f3))

readcol, dats_dir+'p16-17.dat', r4, f4, a4
d44 = dconv(r4, scale)
mag44 = -2.5*alog10(f4/a4)
dmag44 = mag44*(2.5/alog(10)/sqrt(f4))

readcol, dats_dir+'p17-18.dat', r5, f5, a5
d45 = dconv(r5, scale)
mag45 = -2.5*alog10(f5/a5)
dmag45 = mag45*(2.5/alog(10)/sqrt(f5))

;xplt = archplt(rx, xmag, uxmag_err, lxmag_err, rx1, xmag1, uxmag_err1, $
;lxmag_err1, rx2, xmag2, xmag_err2, rx3, xmag3, xmag_err3, d4, mag4, $
;'xplt');, xrange=[-1.3, 46], yrange=[30,10])

;yplt = archplt(ry, ymag, uymag_err, lymag_err, ry1, ymag1, uymag_err1, $
;lymag_err1, ry2, ymag2, ymag_err2, ry3, ymag3, ymag_err3, d4, mag4, $
;'yplt');, xrange=[-1.3,46], yrange=[30,10])


ind = where(finite(xmag))
ind = ind[0:fix(n_elements(ind)-3)]
rx = rx[ind] & xmag = xmag[ind] & uxmag_err = uxmag_err[ind] & lxmag_err = lxmag_err[ind]
ind = where(finite(ymag))
ind = ind[0:fix(n_elements(ind)-2)]
ry = ry[ind] & ymag = ymag[ind] & uymag_err = uymag_err[ind] & lymag_err = lymag_err[ind]


ind1 = where(finite(xmag1))
ind1 = ind1[0:fix(n_elements(ind1)-3)]
rx1 = rx1[ind1] & xmag1 = xmag1[ind1] & uxmag_err1 = uxmag_err1[ind1] & lxmag_err1 = lxmag_err1[ind1]
ind1 = where(finite(ymag1))
ind1 = ind1[0:fix(n_elements(ind1)-2)]

ry1 = ry1[ind1] & ymag1 = ymag1[ind1] & uymag_err1 = uymag_err1[ind1] & lymag_err1 = lymag_err1[ind1]

@colors_kc
!p.font=-1
!p.thick=4.8
!x.thick=4.2
!y.thick=4.2

set_plot, 'ps'
device, filename="sfp.eps", encapsulated=1, xsize=20, ysize=20
cgerase & multiplot, [2,2], /square, mxtitle='!17R !6[!17kpc!6]', $
mxtitoffset=2, mytitoffset=0.9, $
mytitle='!7l !6[!17mag arcsec$\up-2$!6]!17', mxtitsize=2, mytitsize=2

; X PLOT ----------------------
ss=0.9
cgplot, rx, xmag, err_ylow=lxmag_err, err_yhigh=uxmag_err, psym=4, $
symsize=ss, color='slate gray', xrange=[0.003,60], yrange=[28,10], $
/xlog, /err_clip
cgplot, rx1, xmag1, err_ylow=lxmag_err1, err_yhigh=uxmag_err1, $
psym=4, symsize=ss, color='spring green', /overplot
cgplot, d4, mag4+16.2, psym=4, symsize=ss, color='orange', /overplot, $
err_ylow=dmag4, err_yhigh=dmag4
;cgplot, d42, mag42+7.2, psym=-2, symsize=ss, color='blue', /overplot
;cgplot, d43, mag43+7.2, psym=-2, symsize=ss, color='pink', /overplot
;cgplot, d44, mag44+7.2, psym=-2, symsize=ss, color='purple', /overplot
;cgplot, d45, mag45+10.2, psym=-2, symsize=ss, color='black', /overplot

multiplot





cgplot, rx, xmag, err_ylow=lxmag_err, err_yhigh=uxmag_err, psym=4, $
symsize=ss, color='slate gray', xrange=[-1.5,47], yrange=[28,10], /err_clip
cgplot, rx1, xmag1, err_ylow=lxmag_err1, err_yhigh=uxmag_err1, $
psym=4, symsize=ss, color='spring green', /overplot
cgplot, d4, mag4+16.2, psym=4, symsize=ss, color='orange', /overplot, $
err_ylow=dmag4, err_yhigh=dmag4

;cgplot, d42, mag42+7.2, psym=-2, symsize=ss, color='blue', /overplot
;cgplot, d43, mag43+7.2, psym=-2, symsize=ss, color='pink', /overplot
;cgplot, d44, mag44+7.2, psym=-2, symsize=ss, color='purple', /overplot
;cgplot, d45, mag45+10.2, psym=-2, symsize=ss, color='black', /overplot


cgtext, -47, 26.5, 'Major Axis'
cglegend, title=['NE (Wedge cut)','SW (Wedge cut)','Radial (Star count)'], psym=[4,4,4], $
color=['spring green','slate gray','orange'], location=[7.7,10.7], vspace=2.0, $
charsize=1.3, /data, length=0.0, /box
multiplot
; -----------------------------
; Y PLOT ----------------------

cgplot, ry, ymag, err_ylow=lymag_err, err_yhigh=uymag_err, psym=4, $
symsize=ss, color='slate gray', xrange=[0.003,60], yrange=[28,10], $
/xlog, /err_clip
cgplot, ry1, ymag1, err_ylow=lymag_err1, err_yhigh=uymag_err1, $
psym=4, symsize=ss, color='spring green', /overplot
cgplot, d4, mag4+16.2, psym=4, symsize=ss, color='orange', /overplot, $
err_ylow=dmag4, err_yhigh=dmag4
multiplot

cgplot, ry, ymag, err_ylow=lymag_err, err_yhigh=uymag_err, psym=4, $
symsize=ss, color='slate gray', xrange=[-1.5,47], yrange=[28,10], /err_clip
cgplot, ry1, ymag1, err_ylow=lymag_err1, err_yhigh=uymag_err1, $
psym=4, symsize=ss, color='spring green', /overplot
cgplot, d4, mag4+16.2, psym=4, symsize=ss, color='orange', /overplot, $
err_ylow=dmag4, err_yhigh=dmag4
cglegend, title=['SE (Wedge cut)','NW (Wedge cut)','Radial (Star count)'], psym=[4,4,4], $
color=['spring green','slate gray','orange'], location=[7.7,10.7], vspace=2.0, $
charsize=1.3, /data, length=0.0, /box
cgtext, -47, 26.5, 'Minor Axis'
multiplot

multiplot, /reset
device, /close

end
