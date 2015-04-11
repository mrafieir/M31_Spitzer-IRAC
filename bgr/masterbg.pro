; a short script for computing statistics of 
; background galaxies based on data from 
; Kim et al. (2012)

; read the cmd
readcol, "./sbp.dat", mag_irac, color_irac

; path to data files
wdir = "/Users/mrafieir/Projects/Andromeda/cats/Kim12/"

; read files into vectors
readcol, wdir+"SDWFS_45.dat", mag_sdwfs, n_sdwfs
readcol, wdir+"H-ATLAS+Spitzer_45.dat", mag_hs, n_hs
readcol, wdir+"fazio_45.dat", mag_fls, n_fls
readcol, wdir+"aeges_45.dat", mag_egs, n_egs

end
