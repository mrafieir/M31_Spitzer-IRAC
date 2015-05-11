; make a master hit (i.e. coverage) map based on
; both 3.6 and 4.5um hit maps <-- the two are not the same!
; this is useful for finding the net coverage of the catalog
; which is made by sextractor.

; path to input
dir_in = "~/Projects/project_80032/maps/"
; path to output
dir_out = "~/Projects/project_80032/pr_maps/hits/"

; load I1 and I2 hit maps
hit1ew = mrdfits(dir_in+"I1_M31.EW.big_mosaic_cov.fits", 0, header1ew)
hit2ew = mrdfits(dir_in+"I2_M31.EW.big_mosaic_cov.fits", 0, header2ew)
hit1ns = mrdfits(dir_in+"I1_M31.NS.noCRs_mosaic_cov.fits", 0, header1ns)
hit2ns = mrdfits(dir_in+"I2_M31.NS.noCRs_mosaic_cov.fits", 0, header2ns)
; along major axis
master_hit_ew = hitmaker(hit1ew, hit2ew, header1ew, $
		dir_out+"masterhit_EW.fits")
; along minor axis
master_hit_ns = hitmaker(hit1ns, hit2ns, header1ns, $
		dir_out+"masterhit_NS.fits")

END
