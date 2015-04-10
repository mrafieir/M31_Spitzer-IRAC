; convert irac to AB -or- vice versa.
function irac2ab, inmag, channel, mode

case mode of 
	0: cal1 =	+2.78d	; IRAC to AB 
   	   cal2 =	+3.26d	
	1: cal1 =	-2.78d	; AB to IRAC
   	   cal2 =	-3.26d	
endcase

case channel of
	1: return, inmag + cal1	; [3.6]
	2: return, inmag + cal2	; [4.5]
	3: return, inmag + cal1 - cal2	; [3.6]-[4.5]
endcase
end
