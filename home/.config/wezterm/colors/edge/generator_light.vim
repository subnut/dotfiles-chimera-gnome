" vim: et sw=2 sts=2 ts=2
colorscheme edge
set background=dark
let s:dpalette = edge#get_palette(g:edge_style, '', {})

set background=light
let s:palette = edge#get_palette(g:edge_style, '', {})
let s:palette.bg_yellow = s:dpalette.yellow
let s:palette.bg_cyan = s:dpalette.cyan
let s:palette = foreach(s:palette,
      \"let s:palette[v:key] = v:val[0]")

let s:map1 = split("black red green yellow blue purple cyan bg_grey")
let s:map2 = split("dim red green yellow blue purple cyan")
let s:map2 = map(s:map2, '"bg_" .. v:val') + ["grey"]

lcd <sfile>:h
redir! > EdgeLight.toml
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
