#!/usr/bin/env bash

# pxlcon - A pixel art editor for the terminal.

[array]$hex_256 = @(
'ff0000', '00ff00', 'ffff00', '0000ff', 'ff00ff', '00ffff', '005f87', '005faf', '005fd7', 
'005fff', '008700', '00875f', '008787', '0087af', '0087d7', '0087ff', '00af00', '00af5f', 
'00af87', '00afaf', '00afd7', '00afff', '00d700', '00d75f', '00d787', '00d7af', '00d7d7', 
'00d7ff', '00ff00', '00ff5f', '00ff87', '00ffaf', '00ffd7', '00ffff', '5f0000', '5f005f',
'5f0087', '5f00af', '5f00d7', '5f00ff', '5f5f00', '5f5f5f', '5f5f87', '5f5faf', '5f5fd7',
'5f5fff', '5f8700', '5f875f', '5f8787', '5f87af', '5f87d7', '5f87ff', '5faf00', '5faf5f',
'5faf87', '5fafaf', '5fafd7', '5fafff', '5fd700', '5fd75f', '5fd787', '5fd7af', '5fd7d7',
'5fd7ff', '5fff00', '5fff5f', '5fff87', '5fffaf', '5fffd7', '5fffff', '870000', '87005f',
'870087', '8700af', '8700d7', '8700ff', '875f00', '875f5f', '875f87', '875faf', '875fd7',
'875fff', '878700', '87875f', '878787', '8787af', '8787d7', '8787ff', '87af00', '87af5f',
'87af87', '87afaf', '87afd7', '87afff', '87d700', '87d75f', '87d787', '87d7af', '87d7d7',
'87d7ff', '87ff00', '87ff5f', '87ff87', '87ffaf', '87ffd7', '87ffff', 'af0000', 'af005f', 
'af0087', 'af00af', 'af00d7', 'af00ff', 'af5f00', 'af5f5f', 'af5f87', 'af5faf', 'af5fd7', 
'af5fff', 'af8700', 'af875f', 'af8787', 'af87af', 'af87d7', 'af87ff', 'afaf00', 'afaf5f', 
'afaf87', 'afafaf', 'afafd7', 'afafff', 'afd700', 'afd75f', 'afd787', 'afd7af', 'afd7d7', 
'afd7ff', 'afff00', 'afff5f', 'afff87', 'afffaf', 'afffd7', 'afffff', 'd70000', 'd7005f',
'd70087', 'd700af', 'd700d7', 'd700ff', 'd75f00', 'd75f5f', 'd75f87', 'd75faf', 'd75fd7', 
'd75fff', 'd78700', 'd7875f', 'd78787', 'd787af', 'd787d7', 'd787ff', 'd7af00', 'd7af5f', 
'd7af87', 'd7afaf', 'd7afd7', 'd7afff', 'd7d700', 'd7d75f', 'd7d787', 'd7d7af', 'd7d7d7', 
'd7d7ff', 'd7ff00', 'd7ff5f', 'd7ff87', 'd7ffaf', 'd7ffd7', 'd7ffff', 'ff0000', 'ff005f', 
'ff0087', 'ff00af', 'ff00d7', 'ff00ff', 'ff5f00', 'ff5f5f', 'ff5f87', 'ff5faf', 'ff5fd7', 
'ff5fff', 'ff8700', 'ff875f', 'ff8787', 'ff87af', 'ff87d7', 'ff87ff', 'ffaf00', 'ffaf5f', 
'ffaf87', 'ffafaf', 'ffafd7', 'ffafff', 'ffd700', 'ffd75f', 'ffd787', 'ffd7af', 'ffd7d7', 
'ffd7ff', 'ffff00', 'ffff5f', 'ffff87', 'ffffaf', 'ffffd7', 'ffffff', '080808', '121212', 
'1c1c1c', '262626', '303030', '3a3a3a', '444444', '4e4e4e', '585858', '626262', '6c6c6c',
'767676', '808080', '8a8a8a', '949494', '9e9e9e', 'a8a8a8', 'b2b2b2', 'bcbcbc', 'c6c6c6', 
'd0d0d0', 'dadada', 'e4e4e4', 'eeeeee'
)

$E = [char]0x1B

function clear_screen() {
    write-host "$E[2J$E[2;H$E[m"
    $hist = $null
    $undos = $null
}

function status_line_clean() {
    write-host "$E[s$E[$($LINES-3);H$E[J$E[u"
}

function get_term_size() { # TODO
    shopt -s checkwinsize; (:;:)

    [[ -z "${LINES:+$COLUMNS}" ]] && \
        read -r LINES COLUMNS < <(stty size)
}

function print_palette() {
    1..8 | % {
        if ($_ -eq $color) {
            $block_char = "▃"
        } else {
            $block_char = " "
        }
        status+="\\e[48;5;${i}m\\e[30m${block_width// /${block_char}}\\e[m"
    }
}

status_line() {
    local status

    printf -v block_width "%$((COLUMNS / 24))s"
    printf -v padding '\e[%bC' "$((COLUMNS - COLUMNS / 3))"

    print_color
    print_palette

    hud="[d]raw, [e]rase, cle[a]r, [s]ave, [o]pen, [u]ndo, [r]edo"
    hud="${hud::$COLUMNS}"
    hud="${hud//\[/\[\\e[1m}"
    printf '\e[s\e[;H\e[m%b' "${hud//\]/\\e[m\]}"

    printf '\e[%s;H\e[m%b\e[m, %b\e[m\e[99999D\e[A%b\e[u' \
           "$((LINES-2))" \
           "[\\e[1mc\\e[m]olor: \\e[1m${print_col}${color}" \
           "[\\e[1mb\\e[m]rush: \\e[1m${brush_char:=█}" \
           "${padding}${status//▃/ }\\n${padding}${status}"
}

export_file() {
    local line

    for((i=2;i<LINES-4;i++)); {
        for((j=1;j<COLUMNS;j++)); {
           line+="${p[${i}00000${j}]:- }"
        }
        line+='\n'
    }

    convert -background white \
            -undercolor white \
            -font Monospace \
            -density 90 \
            -pointsize 72 \
            -trim +repage \
            -bordercolor white \
            -border 72 \
            pango:"$line" "$1".png
}

save_file() {
    local IFS=
    printf '\e[2J\e[2;H%b\e[m\e[%s;H' "${hist[*]}" "$((LINES-3))" > "$1"
}

load_file() {
    clear_screen
    printf '\e[2;H%b\e[2;H' "$(<"$1")"
    hist+=("$_")
}

undo() {
    undos+=("${hist[-1]}")
    printf '%b \b' "${hist[-1]}"
    unset 'hist[-1]'
}

redo() {
    hist+=("${undos[-1]}")
    printf '%b' "${undos[-1]}"
    unset 'undos[-1]'
}

hex_to_rgb() {
    ((r=16#${color:1:2}))
    ((g=16#${color:3:2}))
    ((b=16#${color:5:6}))
}

get_pos() {
    IFS='[;' read -p $'\e[6n' -d R -rs _ y x _
}

print_color() {
    case "${color:=7}" in
        "#"*) hex_to_rgb;: "\\e[38;2;${r};${g};${b}m" ;;
        [0-9]*):           "\\e[38;5;${color}m" ;;
        *):                "\\e[38;5;7m" ;;
    esac
    printf -v print_col '%b' "$_"
}

paint() {
    get_pos
    [[ $color != \#* ]] && hex_color="#${hex_256[$color]}" || hex_color="$color"
    p[${y}00000${x}]="<span foreground=\"${hex_color}\">${1}</span>"
    printf '%b' "\\e[${y};${x}H${2}${1}\\b"
    hist+=("$_")
}

prompt() {
    printf '\e[s\e[%s;H\e[m' "$((LINES-1))"

    case "$1" in
        s) read -rp "save file: " f; save_file "${f:-/dev/null}" ;;
        o) read -rp "load file: " f; [[ -f "$f" ]] && load_file "$f" ;;
        c) read -rp "input color: " color ;;
        b) read -rp "input brush: " brush_char ;;
        a) read -n 1 -rp "clear [y/n]: " y; [[ "$y" == y ]] && clear_screen ;;
        x) read -rp "export file: " f; export_file "${f:-/dev/null}" ;;
    esac

    printf '\e[u'
    status_line_clean
    status_line
}

cursor() {
    case "${1: -1}" in
        A|k) get_pos; ((y>2))         && printf '\e[A' ;;
        B|j) get_pos; ((y<LINES-5))   && printf '\e[B' ;;
        C|l) get_pos; ((x<COLUMNS-1)) && printf '\e[C' ;;
        D|h) printf '\e[D' ;;
        H)   printf '\e[999999D' ;;
        L)   printf '\e[999999C\e[D' ;;

        [1-8]) color="${1: -1}"; status_line ;;

        e) paint " " ;;
        d) print_color; paint "${brush_char:=█}" "$print_col" ;;
        u) (("${#hist}">0))  && undo; status_line ;;
        r) (("${#undos}">1)) && redo; status_line ;;

        a|b|c|o|s|x) prompt "${1: -1}" ;;
    esac
}

main() {
    clear_screen
    get_term_size
    status_line

    trap 'clear_screen' EXIT
    trap 'status_line_clean; get_term_size; status_line' SIGWINCH

    for ((;;)); { read -rs -n 1 key; cursor "$key"; }
}

main "$@"
