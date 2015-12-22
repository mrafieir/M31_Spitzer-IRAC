readcol, "./dats/irac-errcor", irac1, irac2, format='d,d', comm="#"
readcol, "./dats/1gyr.dat", i11, i12, format='d,d', comm='#'
readcol, "./dats/3gyr.dat", i21, i22, format='d,d', comm='#'
readcol, "./dats/10gyr.dat", i31, i32, format='d,d', comm='#'

xrange = [-1,2.5]
yrange = [18.7,9]

!p.thick=9
!x.thick=10
!y.thick=10
!p.charthick=8
!p.font=-1
!p.charsize=3.8

color = irac1-irac2
dm = 24.47

set_plot, 'ps'
device, filename="fig5.eps", encapsulated=1, /cmyk, xsize=40, ysize=40

cgplot, color, irac2, $
xtitle='!6[3.6]-[4.5]', ytitle='[4.5]', $
xrange=xrange, yrange=yrange, $
psym=16, symsize=0.3

cgplot, i11-i12, i12+dm, /overplot, linestyle=3, thick=15, color='cyan'
cgplot, i21-i22, i22+dm, /overplot, linestyle=0, thick=15, color='yellow'
cgplot, i31-i32, i32+dm, /overplot, linestyle=5, thick=15, color='red'

device, /close

cgps2raster, 'fig5.eps', /png, width=800

end
