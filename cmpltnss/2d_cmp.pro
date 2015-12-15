
; +
; a script to apply 2d completeness results 
; to the output from fbgr_cmd analysis..
;
; written by Masoud Rafiei <mrafiei.ravandi@gmail.com>
;	© August 2015
; ----------
; -

outname = 'out-ns'

; read 2d completeness
readcol, '~/Projects/project_80032/cats/ns_2d_complete.txt', d, m1, m2, m3, m4, m5, m6, m7, m8, comment='#', format='d,d,d,d,d,d,d,d,d'

; read the catalog
readcol, './in-ns', ra, dec, i1, i2, rgc, drgc, p0, $
comment='#', format='d,d,d,d,d,d,d'

p = p0

; init loop vectors for the 2d completeness
d = reverse(d) ; l-h
i1bin = findgen(8) + 14.5d

dstep = (d[1]-d[0])/2d
istep = 0.5d

m = reverse([[m1],[m2],[m3],[m4],[m5],[m6],[m7],[m8]])

for x=0, n_elements(i1bin)-1 do begin
	for y=0, n_elements(d)-1 do begin
		indx = where((i1 ge i1bin[x]-istep) AND (i1 lt i1bin[x]+istep), cnx)
		case y of
		0: indy = where(rgc lt d[y]+dstep, cny)
		n_elements(d)-1: indy = where(rgc gt d[y]-dstep, cny)
		else: indy = where((rgc ge d[y]-dstep) AND (rgc lt d[y]+dstep), cny)
		endcase
		if cnx gt 0 and cny gt 0 then begin
			match, indx, indy, subx, suby
			ind = indx[subx]
			p[ind] = p[ind] / m[y,x]
		endif	
	;print, i1bin[x], d[y], m[y,x], minmax(p[ind])
	print, i1bin[x], minmax(p[ind])
	endfor
endfor

forprint, ra, dec, p0, p, drgc, text=outname, /nocomment

end

