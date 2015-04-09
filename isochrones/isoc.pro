; plot isochrones
file = './isoc-1g'
d = 788d ; Kpc - distance to M31
dm = 5 * alog10(d/10d) ; distance modulus

readcol, file, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10

x = v9 - v10	; color
y = v10 + dm	; apparent mag

plot, x, y, psym=0, yrange=[20,0]

end
