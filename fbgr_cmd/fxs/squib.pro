; compute source count in a cmd bin, given
; mag & color vectors of all sources in a catalog
function squib, mag, color, xl, xh, yl, yh, mode

; select sources based on input constraints
ind1 = where ( (color ge xl) and $
	(color lt xh), count1 ) ; along color axis
ind2 = 	where( (mag ge yl) and $
	(mag lt yh), count2 ) ; along mag axis
; match indeces ==> # sources in the bin
match, ind1, ind2, sub1, sub2, count=count
if count1 gt 0 and count2 gt 0 and count gt 0 then begin
; return counts as double precision
; OR indeces as integers
case mode of
0: return, double(count)
1: return, ind1[sub1]
end

endif else return, -1

end
