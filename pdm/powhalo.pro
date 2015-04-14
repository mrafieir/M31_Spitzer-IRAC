function powhalo, R, hpar

I_s = hpar[0] & R_s = hpar[1]
a_h = hpar[2] & alpha = hpar[3]

par = (1+(R_s/a_h)^2d) / (1+(R/a_h)^2d)
return, I_s * par^alpha
end
