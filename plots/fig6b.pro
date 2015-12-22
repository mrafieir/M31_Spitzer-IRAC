readcol, "./dats/wise_all.dat", i1, i2, w1, w2, format='d,d,d,d', comm="#"
readcol, "./dats/wise_all_magcut.dat", i1x, i2x, w1x, w2x, jx, kx, format='d,d,d,d,d,d', comm="#"
readcol, "./dats/iraccmd.dat", irac1, irac2, iracp0, format='d,d,d', comm="#"
readcol, "./dats/isoc1.dat", sj1, sk1, si1_1, si2_1, format='d,d,d,d', comm='#'
readcol, "./dats/isoc3.dat", sj2, sk2, si1_2, si2_2, format='d,d,d,d', comm='#'
readcol, "./dats/isoc10.dat", sj3, sk3, si1_3, si2_3, format='d,d,d,d', comm='#'

xrange = [-1,2]
yrange = [18,12]
mxrange = [-0.25,2]
myrange = [16,9]

!p.thick=9
!x.thick=10
!y.thick=10
!p.charthick=8
!p.font=-1
!p.charsize=3.8

!p.thick=9
!x.thick=10
!y.thick=10
!p.charthick=8
!p.font=-1
!p.charsize=3.8
set_plot, 'ps'
device, filename="fig6b.eps", encapsulated=1, /cmyk, xsize=40, ysize=40
cgplot, jx-kx, kx, xtitle=textoidl('!6J-K_s'), ytitle=textoidl('K_s'), $
xrange=mxrange, yrange=myrange, $
color='orange', psym=1, symsize=0.7
device, /close
cgps2raster, 'fig6b.eps', /png, width=800
end
