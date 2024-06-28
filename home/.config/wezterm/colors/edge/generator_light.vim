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

let s:map1 = split("red green yellow blue purple cyan grey_dim")
let s:map2 = ["grey"] + map(s:map1[0:-2], '"bg_" .. v:val') + ["bg4"]
let s:black_dim = "#595e69"

lcd <sfile>:h
redir! > EdgeLight.toml
echo '[colors]'

echo 'cursor_bg = "' .. s:black_dim .. '"'
for s:x in split("background selection_fg"
      \.. " cursor_fg cursor_border")
  echo s:x .. ' = "' .. s:palette.bg0 .. '"'
endfor
for s:x in split("foreground selection_bg")
  echo s:x .. ' = "' .. s:palette.fg .. '"'
endfor

echo 'ansi = ['
echo '    "'.. s:black_dim ..'",'
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
