scale = 60d / 206265d * 785d ; kpc
d = 0.5

xmin1= 0.01
xmax1 = 260
xmin2 = 0
xmax2 = 205

ymin = 10.5
ymax = 28.6

readcol, './dats/SBprofile.dat', r1, f1, f1s, format='d,d,d', comm='#'
ind1 = where(r1 lt 65)
ind2 = where(r1 gt 65 and r1 lt 90)
ind3 = where(r1 gt 90)

readcol, './dats/avgprof.dat', r2, f2, f2s, format='d,d,d', comm='#'
r2 = r2 / 60d

!p.thick=5.5
!x.thick=8
!y.thick=8
!p.charthick=6
!p.font=-1
!p.charsize=2.4
charbar=2.4
sg = 2.5
set_plot, 'ps'
device, filename="fig9.eps", encapsulated=1, /cmyk, xsize=40, ysize=40

cgerase & multiplot, [2,2], $
mxtitle=textoidl('!6R_{deproj} [arcmin]'), $;mytitle=textoidl('\mu [mag arcsec^{-2}]'), $
mxtitsize=charbar, mytitsize=charbar, $
mxtitoffset=4.2, mytitoffset=4.9;, /doyaxis
multiplot
multiplot
; avg prof	
	cgplot, r2, f2, linestyle=5, color='gray', thick=14, $
	xrange=[xmin1,xmax1], yrange=[ymax, ymin], /xlog, xtickf='(a1)', xstyle=9, $
	ytickf='(a1)'
	cgtext, 0.0025, 20, textoidl('\mu [mag arcsec^{-2}]'), alignment=0.5, $
	charsize=charbar, orient=90

	labels = ['25', '20', '15']
	for j=0,2 do cgtext, 0.006, double(labels[j])+0.4, labels[j], Alignment=0.5
		
	labels = ['0.01', '0.1', '1', '10', '100']
	for j=0,4 do cgText, double(labels[j]), ymax+1.15, labels[j], Alignment=0.5    

; red line & top axis
	indred = where(r1 lt 200 and r1 gt 4, countred)
	indred1 = r1[indred[0]]
	cgarrow, indred1, 26, indred1, 24.5, /solid, /data, thick=8, hthick=1, color='black'
	cgarrow, indred1, 26, indred1, 27.5, /solid, /data, thick=8, hthick=1, color='black' 
	
	cgplot, r1[indred], dblarr(countred)+26, linstyle=2, color='black', $
	thick=8, /overplot

; dat points
	cgplot, r1[ind1], f1[ind1], psym=4, symsize=sg, color='black', $
	err_yhigh=f1s[ind1], err_ylow=f1s[ind1], err_width=0, /overplot
	
	cgplot, r1[ind2], f1[ind2], psym=4, color='medium gray', symsize=sg, /overplot
	
	cgplot, r1[ind3], f1[ind3], psym=6, color='black', symsize=sg, $
	err_yhigh=f1s[ind3], err_ylow=f1s[ind3], err_width=0, /overplot
	
	cgaxis, xaxis=1, xrange=[xmin1,xmax1]*scale, /xlog, xtickf='(a1)', /save
        labels = ['0.01', '0.1', '1', '10']
        for j=0,3 do cgText, double(labels[j]), ymin-0.4, labels[j], Alignment=0.5


multiplot
; avg prof
	cgplot, r2, f2, linestyle=5, color='gray', thick=10, $
	xrange=[xmin2,xmax2], yrange=[ymax, ymin], xtickf='(a1)', xstyle=9

	labels = ['0', '50', '100', '150', '200']
	for j=1,4 do cgText, double(labels[j]), ymax+1.15, labels[j], Alignment=0.5

; dat points
	cgplot, r1[ind1], f1[ind1], psym=4, symsize=sg, color='black', $
	err_yhigh=f1s[ind1], err_ylow=f1s[ind1], err_width=0, /overplot

	cgplot, r1[ind2], f1[ind2], psym=4, symsize=sg, color='medium gray', /overplot
	
	cgplot, r1[ind3], f1[ind3], psym=6, symsize=sg, color='black', $
	err_yhigh=f1s[ind3], err_ylow=f1s[ind3], err_width=0, /overplot

	cgaxis, xaxis=1, xrange=[xmin2,xmax2]*scale, xtickf='(a1)', /save
	labels = ['0', '10', '20', '30', '40', '50']
	for j=0,5 do cgtext, double(labels[j]), ymin-0.4, labels[j], Alignment=0.5
	cgtext, 0, ymin-2.05, textoidl('R_{deproj} [kpc]'), charsize=charbar, align=0.5
multiplot, /reset
device, /close
end
