dir = '../cats/fgr_input'
readcol, dir+"/tirac", i1, i1s, i2, i2s
readcol, dir+"/trg", t1, t2

r1 = trilgen(i1, i1s, t1)
r2 = trilgen(i2, i2s, t2)

forprint, r1, r2, text='trilnew', /nocomment

END
