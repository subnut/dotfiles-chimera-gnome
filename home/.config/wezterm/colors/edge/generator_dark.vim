" vim: et sw=2 sts=2 ts=2
colorscheme edge
set background=light
let s:lpalette = edge#get_palette(g:edge_style, '', {})
let s:lpalette = foreach(s:lpalette,
      \"let s:lpalette[v:key] = v:val[0]")

set background=dark
let s:dpalette = edge#get_palette(g:edge_style, '', {})
let s:dpalette = foreach(s:dpalette,
      \"let s:dpalette[v:key] = v:val[0]")

let s:palette = deepcopy(s:dpalette)
for s:name in split("red green yellow blue purple cyan")
  let s:palette["bg_" .. s:name] = s:palette[s:name]
  let s:palette[s:name] = s:lpalette[s:name]
endfor
let s:palette.purple = s:lpalette.bg_purple
let s:palette.grey = s:lpalette.bg_grey

let s:map1 = split("black red green yellow blue purple cyan grey")
let s:map2 = ["bg4"] + map(s:map1[1:-1], '"bg_" .. v:val')

lcd <sfile>:h
redir! > EdgeDark.toml
echo '[colors]'

for s:x in split("background selection_fg")
  echo s:x .. ' = "' .. s:palette.bg0 .. '"'
endfor
echo 'cursor_fg = "' .. s:palette.bg2 .. '"'
for s:x in split("foreground selection_bg"
      \ .. " cursor_bg cursor_border")
  echo s:x .. ' = "' .. s:palette.fg .. '"'
endfor

echo 'ansi = ['
for s:x in s:map1
  echo '    "' .. s:palette[s:x] .. '",'
endfor
echo ']'

echo "brights = ["
for s:x in s:map2
  echo '    "' .. s:palette[s:x] .. '",'
endfor
echo "]"

redir END
