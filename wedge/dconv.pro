function dconv, rad, scale

d = 785d ; Kpc
z = 0.00100d ; redshift
d_a = 788d / (1d + z) ; angular diameter distance
radian = 206265d ; arcsec in 1 radian

rad = rad * scale ; distance values with pixel size in arcsec
rad = rad / radian ; distance values with pixel size in radian 
rad = rad * d_a ; distances in Kpc

return, rad
end
