; apply IRAC uncertainties on 
; the trilegal stellar model
; functions in use: `trilgen.pro'
; © Masoud Rafiei Ravandi
; <mrafiei.ravandi@gmail.com>
dir = '~/Dropbox/'
readcol, dir+"/data", i1, i1s, i2, i2s
readcol, dir+"/model", t1, t2

r1 = trilgen(i1, i1s, t1)
r2 = trilgen(i2, i2s, t2)

forprint, r1, r2, text='model_convolved', /nocomment

END
