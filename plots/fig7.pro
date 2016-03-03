readcol, "./dats/pan-yes", g2, i2, format='d,d', comm='#'
readcol, "./dats/pan-no", g, i, format='d,d', comm='#'

!p.thick=9
!x.thick=10
!y.thick=10
!p.charthick=8
!p.font=-1
!p.charsize=3.8

color = g - i
color2 = g2 - i2

set_plot, 'ps'
device, filename="fig7.eps", encapsulated=1, /cmyk, xsize=40, ysize=40

cgplot, color, i, $
xtitle='!6g-i', ytitle='i', $
xrange=[-1.5,4.5], yrange=[25,16], $
psym=16, symsize=0.3, color='black'

cgplot, color2, i2, $
psym=7, symsize=0.4, color='dark gray', /overplot

data = hist_2d(color, i, bin1=0.1, bin2=0.1)
sdata = size(data, /dim)
y = findgen(sdata[1])/10+min(i)
x = findgen(sdata[0])/10+min(color)

contourLevels = cgConLevels(data, NLevels=5)

cgContour, data, x, y, levels=contourLevels, $
label=0, c_charthick=8, Color='black', c_charsize=3.5, /overplot

data = hist_2d(color2, i2, bin1=0.1, bin2=0.1)
sdata = size(data, /dim)
y = findgen(sdata[1])/10+min(i2)
x = findgen(sdata[0])/10+min(color2)

contourLevels = cgConLevels(data, NLevels=7)

cgContour, data, x, y, levels=contourLevels, $
label=0, Color='medium gray', c_charthick=8, c_charsize=3.5, /overplot

device, /close
;cgps2raster, 'fig7.eps', /png, width=3000
end
