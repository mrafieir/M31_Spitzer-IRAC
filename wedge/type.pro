;+
; NAME:
; type
;
;
; PURPOSE:
; return the type of a variable
;
;
; CATEGORY:
; 
;
;
; INPUTS:
; in: the variable to deterine the type of
;
;
; KEYWORD PARAMETERS:
; WORDS: output in words the type
;
;
; OUTPUTS:
; the type of the variable
;
; EXAMPLE:
; a=dblarr(10)
; print, type(a)
;           5
; print, type(a, /words)
;      DOUBLE
;
;
;
; MODIFICATION HISTORY:
;
;       Tue Jan 22 18:40:02 2008, Brian Larsen
;
;		documented, written previously
;
;-
FUNCTION type, in, WORDS=words
  compile_opt strictarr

  IF NOT keyword_set(words) THEN RETURN, size(in, /type)
  
  

names = [ 'UNDEFINED', $
          'BYTE', $
          'INT', $
          'LONG', $
          'FLOAT', $
          'DOUBLE', $
          'COMPLEX', $
          'STRING', $
          'STRUCT', $
          'DCOMPLEX', $
          'POINTER', $
          'OBJREF', $
          'UINT', $
          'ULONG', $
          'LONG64', $
          'ULONG64' ]

  RETURN, names[size(in, /type)]
END


