function rmsdev, value, s, op

sigma = sqrt( total((value-s[*])^2d) )/sqrt(n_elements(s)-1)

case op of
0: return, sigma
1: return, sigma/sqrt(n_elements(s))
endcase

end
