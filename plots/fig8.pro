readcol, "./dats/iraccmd.dat", i1, i2, p0, format='d,d,d', comm='#'

cl = i1-i2
xrange = [-2,2.5]
yrange=[18.5,13.5]

ind = where(cl gt -2 and cl lt 2.5 and i2 gt 13.6 and i2 lt 18.39)

!p.thick=9
!x.thick=10
!y.thick=10
!p.charthick=8
!p.font=-1
!p.charsize=3.8

set_plot, 'ps'
device, filename="fig8.eps", encapsulated=1, /cmyk, xsize=40, ysize=40
;cgLoadCT, RGB_Table=rainbowPalette
;cgloadct, filename="./fsc_brewer.tbl"
loadct, 64, /silent

cgplot, cl, i2, $
xtitle=textoidl('!6[3.6]-[4.5]'), ytitle=textoidl('[4.5]'), $
xrange=xrange, yrange=yrange, /nodata

c_shift = 0
color_scale = bytscl(p0[ind]) + c_shift
;color_scale[where(color_scale gt 255)] = fix(255)

cgplots, cl[ind], i2[ind], psym=16, symsize=0.4, color='dark gray'
cgplots, cl[ind], i2[ind], psym=16, symsize=0.3, color=color_scale

x = (indgen(2000)-1000)/400d
cgplot, x, 14.1-x, linestyle=5, /overplot
;cgplot, x, 15-x, linstyle=0, /overplot
;cgplot, x*0-0.75, x*10, linestyle=2, /overplot
cgcolorbar, bottom=c_shift, range=[0, 1], /vertical, /right, $
textthick=8, position=[.9, 0.125, .93, 0.90], charsize=3.8

device, /close
;cgps2raster, 'fig8.eps', /png, width=4000
end 
