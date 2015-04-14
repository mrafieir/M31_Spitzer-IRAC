function serbulge, R, bpar

I_e = bpar[0] & R_e = bpar[1] & n = bpar[2]

b_n = 1.9992d * n - 0.3271d

a = - b_n * ((R / R_e)^(1/n) - 1)
return, I_e * exp(a)
end
