; convert ds9 region results to a simple .dat file
; containing [x,y,radius]

fpath = './ds9.reg'
openr, lun, fpath, /get_lun

        string_array = '' ; initialize the string array
        line = ''

        ; read the file line by line, in an array
        while not eof(lun) do begin & $
                readf, lun, line & $
                hash = strmid(line, 0, 1)
        if hash ne '#' then begin ; ignoring comments (i.e. lines
        ; that start with '#'
                string_array = [string_array, line] & $
        endif
        endwhile

arr = strmid(string_array, 7)
arr = strsplit(arr, escape=')', /extract)

n = n_elements(arr)
master = dblarr(n,3)
for z = 0, n-1 do begin
	master[z,*] = double(strsplit(arr[z], ',', /extract))
endfor
master = master[1:*,*]
forprint, master[*,0], master[*,1], master[*,2], text='ds9mask.dat', /nocomment
end
