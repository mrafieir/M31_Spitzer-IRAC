;+
; NAME:
; bootstrap_median
;
;
; PURPOSE:
; compute the bootstrap median
;
;
; CATEGORY:
; Statistics
;
;
; INPUTS:
; X: Values array to compute the bootstrap median of
;
;
; KEYWORD PARAMETERS:
; PLOT: Make a plot the botstrap median
; N_ITER: number of bootstrap iteratons, default:500
; COLOR: Color for the plot
; BACK: background for the plot
; ALL_MEDIANS: Array to contain the array of all medians
; _EXTRA: Extra keywords to plot
;
; OUTPUTS:
; Array containing the median and stddev(median)
;
; EXAMPLE:
; IDL> print, bootstrap_median(findgen(100), /plot)
;      50.0000      5.02490
;
;
;
; MODIFICATION HISTORY:
;
;       Wed Feb 13 16:31:03 2008, Brian Larsen
;		written and tested
;
;-
FUNCTION bootstrap_median2, x, $
                         PLOT = plot, $
                         N_ITER = n_iter, $
                         ALL_MEDIANS = all_medians, $
                         COLOR = color, $
                         BACK = back, $
                         _EXTRA = _EXTRA

  IF n_elements(x) LT 2 THEN $
     message, /ioerror, 'Input must have at least 2 elements'
  n_x = n_elements(x) 
  IF n_elements(n_iter) EQ 0 THEN $
     n_iter = 500
  
  IF type(x) EQ 5 THEN $        ; if input is dbl use dbl
     medians = dblarr(n_iter) ELSE $ ; else use float
        medians = fltarr(n_iter)
  
  median = median(x)
  FOR i = 0L, n_iter-1 DO BEGIN
     ind = resample(n_x, n_x)
     medians[i] = median(x[ind])
  ENDFOR
  
  IF keyword_set(plot) THEN BEGIN 
     plot, medians, $
           psym = 0, $
           /ynozero, $
           xtitle = 'Iteration number', $
           ytitle = 'Bootstrap median', $
           COLOR = color, $
           BACK = back, $
           _STRICT_EXTRA = _EXTRA
     oplot_horiz, median, COLOR = color
  ENDIF 
  
  IF arg_present(ALL_MEDIANS) THEN $
     all_medians = medians
  
  return, [median, stddev(medians)]
END
