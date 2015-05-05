; +
;   NAME: scountplt
;
;   PURPOSE: plot source count profile
;
; © Masoud Rafiei Ravandi
; Email:        mrafiei.ravandi@gmail.com
;-
;-----------------

scale = 1.1999d ; pixel sscale in arcsec
readcol, '~/Projects/project_80032/cats/strcount_input/dats/profile.dat', r, f, a

d = dconv(r, scale) ; convert pixels to kpc
;nsr = 1d/sqrt(f/a) 
;err = abs(-2.5*alog10(1d - nsr))
mag = -2.5*alog10(f/a) ; convert flux to mag

@colors_kc
!p.font=-1
!p.thick=5.8
!x.thick=2.8
!y.thick=2.8

set_plot, 'ps'
device, filename="plt3.eps", encapsulated=1, xsize=22, ysize=13
cgerase & multiplot, [1,1], mxtitle='!17R !6[!17kpc!6]', mxtitoffset=-0.9, $
mytitoffset=3, mytitle='!7l !6[!17mag arcsec$\up-2$!6]!17', mxtitsize=1.5, mytitsize=1.5
cgplot, d, (mag)+14.5, xrange=[18,38], yrange=[25,23.8], aspect=0.5, $
color='tomato', symsize=1, psym=5
multiplot, /reset
device, /close

END
