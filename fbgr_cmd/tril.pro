; apply IRAC uncertainties on 
; the trilegal stellar model
; functions in use: `trilgen.pro'
; © Masoud Rafiei Ravandi
; <mrafiei.ravandi@gmail.com>
dir = '~/Projects/project_80032/cats/fgr_input'
readcol, dir+"/M31_new", i1, i1s, i2, i2s
readcol, dir+"/TRIL_M31_new", t1, t2

r1 = trilgen(i1, i1s, t1)
r2 = trilgen(i2, i2s, t2)

forprint, r1, r2, text='model_convolved', /nocomment

END
