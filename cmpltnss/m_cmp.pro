; a script to find the completeness by fitting a line to the 
; number counts d(logN)/dm
area = 3.8423337d ; total coverage obtained by './cmp_area.pro'
bin = 1. ; magnitude bin size
maglimit = 17.	; upper magnitude limit for the fit

cat = mrdfits("../cats/iracfits", 1) ; all irac sources
mag1 = cat._3_6_ ; 4" aperture in Vega system
mag1 = mag1[where(mag1 gt 0)]
mag1_err = cat.col7 ; magnitude errors
mag1_err = mag1_err[where(mag1 gt 0)]

; make a histogram of magnitudes and scale by the total coverage
z = histogram(mag1, binsize=bin) / area
x = findgen(n_elements(z)) + 1
x = x * bin
x = x + min(mag1) - bin/2d
; compute error bars for the histogram
dz = sqrt(z)
dz = 1d/(alog(10)*dz)

; ------- line fitting
ind = where(x le maglimit) ; apply the upper limit
; fit with or without the error bars
fit = linfit(x[ind], alog10(z[ind]), chisqr=chi);, sdev=dz[ind])

; make model based on fit parameters
zfit = 10^(fit[1]*x[ind]+fit[0])

; # degrees of freedom
dof = n_elements(ind) - 2

; reduced Chi^2
rchi = chi/dof
print, 'for maglimit of ', maglimit, ', rchi= ', rchi

; ------- plot the result
@colors_kc
!p.font=-1
!p.thick=3.8
!x.thick=2.8
!y.thick=2.8

set_plot, 'ps'
device, filename="cmp-plot.eps", encapsulated=1, xsize=15.5, ysize=13.7
cgerase & multiplot, [1,1], mxtitle='!6[!173.6!6]', mxtitoffset=1.1, $
mytitle='!17dN/dm !6[!17num mag$\up-1$ deg$\up-2$!6]!17', mytitoffset=-1.5, $
mxtitsize=1.5, mytitsize=1.5
cgplot, x, z, psym=4, /ylog, aspect=1, err_yhigh=dz, err_ylow=dz, yrange=[1d0,1d5], xrange=[8.5,27]
cgplot, x[ind], zfit, color=ltorange, /overplot
multiplot, /reset
device, /close

; estimate the completeness by computing the ratio between data and model
; at the 10th element of the magnitude vector (x[9])
f_cmp = 10^(fit[1]*x[9]+fit[0])
print, 'at mag=', x[9], ' ', 'cmp(%)= ', z[9]/f_cmp*100d

end
