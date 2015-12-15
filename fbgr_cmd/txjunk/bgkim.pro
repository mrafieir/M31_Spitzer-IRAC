; junk code from previous analysis
if galxmode then begin
; ********************  Background Galaxies **********************
; ****************************************************************
fitdeg = 2
ymin=16d & ymax=19d & ybin=1d
mag_hs = irac2ab(mag_fls, 2, 1)
n_hs = n_fls * ascale * 4d ; # sources scaled by coverage
par = poly_fit(mag_hs, alog10(n_hs), fitdeg, chisq=chisq, /double) ; fit 2nd deg poly
rchisq = chisq/(n_elements(mag_hs)-fitdeg-1) ; reduced chi^2

; init loop
y = ymin + ybin * findgen((ymax-ymin)/ybin+2) ; mag
noy = n_elements(y) ; # bins covering the cmd
y_mid = dblarr(noy)
n_mid = dblarr(noy)
n_irac = dblarr(noy)

for j = 0, noy-2 do begin ; along mag axis
ncounts = !values.f_nan ; init the variable ncounts (assuming a scalar-formated code)
        ; ------------------------------------------------
        ; -------- select/count sources in cmd bins ------
        ; ------------------------------------------------
        ; --- IRAC (full cat)
        n_irac[j] = squib(irac2, irac1-irac2, xmin, xmax, y[j], y[j+1], 0)
        ind_irac = squib(irac2, irac1-irac2, xmin, xmax, y[j], y[j+1], 1)
        ; -----------
        y_mid[j] = (y[j]+y[j+1])/2 ; middle point
        n_mid[j] = par[0] + par[1] * y_mid[j] + par[2] * y_mid[j]^2d ; estimate bg count using the fit parameters
        n_mid[j] = 10d^(n_mid[j]) ; convert 'alog(source count)' to source count
        midfactor = (n_irac[j] - n_mid[j]) / (n_irac[j])
        if (midfactor gt 0) then begin
        probcol[ind_irac] = probcol[ind_irac] * midfactor
        endif
        print, y_mid[j], n_mid[j], n_irac[j], midfactor

endfor
endif

if plot_set then begin
        ; ------- plot the result
        ;@colors_kc
        !p.font=-1
        !p.thick=3.8
        !x.thick=2.8
        !y.thick=2.8

        set_plot, 'ps'
        device, filename="bg-plot.eps", encapsulated=1, xsize=15.5, ysize=13.7
        cgerase & multiplot, [1,1], mxtitle='!6[!174.5!6]', mxtitoffset=1.1, $
        mytitle='!17dN/dm !6[!17num mag$\up-1$ deg$\up-2$!6]!17', mytitoffset=-1.5, $
        mxtitsize=1.5, mytitsize=1.5
        cgplot, y_mid, n_mid/ascale, psym=4, /ylog, aspect=1, yrange=[1d3,1d5], xrange=[16,20]
        cgplot, y_mid, n_irac/ascale, color=ltorange, /overplot
        multiplot, /reset
        device, /close
endif
