function nanz, map

; replace NAN's with zeros
map[where(finite(map, /nan))] = 0d

return, map
end
