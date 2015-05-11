bin = 1.
zeromag = 30d
name='south'

cat ='/Users/mrafieir/Projects/Andromeda/cats/ProcessedCatalogs/dfc_south'
list = scount(cat) ; now in Kpc

hlist = histogram(list, binsize=bin)
max_range = floor(max(list)-min(list))
r = findgen(max_range+1) + min(list)

mag = zeromag - 2.5d*alog10(hlist)

nsr = 1d / sqrt(hlist)
mag_err = abs(-2.5d*alog10( 1d - nsr ))

forprint, r, mag, mag_err, text=name, /nocomment

end
