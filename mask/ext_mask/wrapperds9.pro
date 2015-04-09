; make square masks over point sources given by a simple .dat file
; containing x and y positions & the radius of masks.
; The file can be made by ds9

function wrapperds9, nx, ny, xyr

readcol, xyr, xpo, ypo, rad, format='d', comment='#'

; initialize the array, mask
ptsmask_ext = dblarr(nx,ny)

for i = 0, n_elements(xpo)-1 do begin
x = fix(xpo[i])
y = fix(ypo[i])
r = fix(1.5d*rad[i])
        ; change pixel values by looping over indeces
        for k = 0, r do begin   ; loop over pixels in X
                for j = 0, r do begin   ; loop over pixels in Y
                xpix = x-fix(r/2d)+k
                ypix = y-fix(r/2d)+j
                  ; make sure indeces are inside the array
                  if ( (xpix lt nx) and (ypix lt ny) ) then begin
                        ptsmask_ext[xpix,ypix] = 1.
                  endif
                endfor
        endfor
endfor

ptsmask_ext[*,6735:8970] = 1.
ptsmask_ext[973:1124,9824:9929] = 1.
ptsmask_ext[1121:1306,9213:9299] = 1.
ptsmask_ext[300:400,14900:15000] = 1.
ptsmask_ext[1500:1600,14600:14700] = 1.
ptsmask_ext[600:700,13700:13900] = 1.
ptsmask_ext[1600:1700,12900:13100] = 1.
ptsmask_ext[1600:1700,11300:11400] = 1.
ptsmask_ext[300:400,6200:6400] = 1.
ptsmask_ext[500:600,3200:3300] = 1.
ptsmask_ext[200:300,1800:1900] = 1.

; additional masking near the right-bottom arm
;ptsmask_ext[13900:14200,1390:1700] = 1.
;ptsmask_ext[14100:14300,1600:1800] = 1.
;ptsmask_ext[13400:13600,800:1000] = 1.
;ptsmask_ext[11700:11800,300:400] = 1.
;ptsmask_ext[8700:9100,500:700] = 1.
;ptsmask_ext[13600:13700,1000:1100] = 1.
;ptsmask_ext[13700:13800,1100:1300] = 1.
;ptsmask_ext[13800:13900,1300:1400] = 1.
;ptsmask_ext[13400:13500,800:1000] = 1.
;ptsmask_ext[14000:14200,1400:1500] = 1.
;ptsmask_ext[11600:11800,300:400] = 1.
;ptsmask_ext[13800:13900,1600:1700] = 1.
;ptsmask_ext[13400:13500,1900:2000] = 1.

; additional masking over bright point sources
;ptsmask_ext[9100:9300,2700:2900] = 1.
;ptsmask_ext[19900:20100,1300:1500] = 1.
;ptsmask_ext[12900:13000,2800:2900] = 1.
;ptsmask_ext[8500:8700,600:800] = 1.

return, ptsmask_ext
end
