function expdisk, R, dpar

I_0 = dpar[0] & R_d = dpar[1]

a = -R/R_d
return, I_0 * exp(a)
end
