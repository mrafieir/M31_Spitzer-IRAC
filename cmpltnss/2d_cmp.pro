
; +
; a script to apply 2d completeness results 
; to the output from fbgr_cmd analysis..
;
; written by Masoud Rafiei <mrafiei.ravandi@gmail.com>
;	© August 2015
; ----------
; -

; read 2d completeness
readcol, '~/Projects/project_80032/cats/ew_2d_complete.txt', d, m1, m2, m3, m4, m5, m6, m7, m8, comment='#', format='d,d,d,d,d,d,d,d,d'

; read the catalog
readcol, '~/Projects/project_80032/cats/ew.dat', ra, dec, i1, i2, p, rgc, $
comment='#', format='d,d,d,d,d,d'

; init loop vectors for the 2d completeness
d = reverse(d) ; l-h
i1bin = findgen(8) + 14.5d

dstep = (d[1]-d[0])/2d
istep = 0.5d

m = reverse([[m1],[m2],[m3],[m4],[m5],[m6],[m7],[m8]])

for x=0, n_elements(i1bin)-1 do begin
	for y=0, n_elements(d)-1 do begin
		indx = where((i1 ge i1bin[x]-istep) AND (i1 lt i1bin[x]+istep))
		case y of
		0: indy = where(rgc lt d[y]+dstep)
		n_elements(d)-1: indy = where(rgc gt d[y]-dstep)
		else: indy = where((rgc ge d[y]-dstep) AND (rgc lt d[y]+dstep))
		endcase
		match, indx, indy, subx, suby
		ind = indx[subx]
		p[ind] = p[ind] / m[y,x]	
	print, i1bin[x], d[y], m[y,x]
	endfor
endfor

forprint, ra, dec, p, rgc/60d, text='output-ew', /nocomment

end

