; a short script for computing statistics of 
; background galaxies based on data from 
; Kim et al. (2012)

; path to data files
wdir = "/Users/mrafieir/Projects/Andromeda/cats/Kim12/"

; read files into vectors
readcol, wdir+"SDWFS_45.dat", mag2_sdwfs, n2_sdwfs
readcol, wdir+"H-ATLAS+Spitzer_45.dat", mag2_hs, n2_hs
readcol, wdir+"fazio_45.dat", mag2_fls, n2_fls
readcol, wdir+"aeges_45.dat", mag2_egs, n2_egs

end
