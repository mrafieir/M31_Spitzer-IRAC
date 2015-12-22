function flxconv, inten, scale, ch

;dn = 0.1088 ; (MJy/sr) / (DN/sec)
;inten = inten * dn ; MJy/sr

case ch of
1:	zmag = 280.9 ; Jy
2:	zmag = 179.7 
endcase
zcon = 8.461595d-6 ; (Jy/pixel) / (MJy/sr) for 0.6"x0.6" pixels
zcon = zcon / (0.6/scale)^2d ; the same unit, but now for the new pixel size!
;zcon =1d
mag0 = zmag / zcon ; (MJy/sr) / pixel
mag0 = 2.5d * alog10(mag0)
print, 'mag0=', mag0
return, -2.5d * alog10(inten) + mag0
end
