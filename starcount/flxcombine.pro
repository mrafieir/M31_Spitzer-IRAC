; combine ew and ns profiles
readcol, './fscount_ew.prt', r1, f1, a1, format='d,d,d'
readcol, './fscount_ns.prt', r2, f2, a2, format='d,d,d'

f = f1 + f2
a = a1 + a2
r = r1

forprint, r, f, a, text='fscount', /nocomment

END
 
