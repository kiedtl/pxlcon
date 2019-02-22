$E = [char]27
$R = "255"
$G = "255"
$B = "255"

$Brush = [text.encoding]::utf8.getstring((226,150,136))
$defBrush = [text.encoding]::utf8.getstring((226,150,136))

$history = New-Object System.Collections.Generic.List[string]

function print($txt) {
	write-host $txt -nonewline
	$history.Add($txt)
}

function save_file($dest) {
	set-content $dest "$E[2J$E[2;H$(($history.ToArray()) -join '')$E[m$E[$(($host.UI.RawUI.WindowSize.Height)-3);H"
}

function load_file($file) {
	clear_screen
	write-host "$E[2;H$(get-content $file)$E[2;H" -nonewline
	# hist+=("$_")
}

function print_menu() {
	$postion = $host.UI.RawUI.CursorPosition
	$postion.Y = 0
	$postion.X = 0
	$host.UI.RawUI.CursorPosition = $postion

	write-host " [$E[38;2;255;255;255md$E[0m]raw,  [$E[38;2;255;255;255me$E[0m]rase,  cle[$E[38;2;255;255;255ma$E[0m]r,  [$E[38;2;255;255;255ms$E[0m]ave,  [$E[38;2;255;255;255mo$E[0m]pen,  [$E[38;2;255;255;255mq$E[0m]uit"
}

function print_status() {
	write-host "$E[$(($host.UI.RawUI.WindowSize.Height)-1);H$E[J" -nonewline
	write-host " [$E[38;2;255;255;255mc$E[0m]olor: $E[38;2;${R};${G};${B}m${R},${G},${B}$E[0m, [$E[38;2;255;255;255mb$E[0m]rush: $Brush" -nonewlin
}

function prompt($mode) {
	write-host "$E[s$E[$(($host.UI.RawUI.WindowSize.Height)-3);H$E[m" -nonewline
	$r = ""

	switch ($mode) {
		s {
			write-host " save as: " -nonewline
			$r = [system.console]::readline() 
		}
		o {
			write-host " open file: " -nonewline
			$r = [system.console]::readline() 
		}
		c {
			write-host " input rgb value: " -nonewline
			$r = [system.console]::readline() 
		}
		b {
			write-host " input rgb value: " -nonewline
			$r = [system.console]::readline() 
		}
		a {
			write-host " clear screen and undo info? [y/n]: " -nonewline
			$r = [system.console]::readline() 
		}
	}

	write-host "$E[u" -nonewline
	write-host "$E[s$E[$(($host.UI.RawUI.WindowSize.Height)-3);H$E[J$E[u" -nonewline
	# status_line

	print_status
	print_menu
	return $r
}

function clear_screen() {
	write-host '$E[2J$E[2;H$E[m' -nonewline
	$history = New-Object System.Collections.Generic.List[string]
	$Brush = $defBrush
	$R = "255"
	$G = "255"
	$B = "255"
}

$postion = $host.UI.RawUI.CursorPosition
$postion.Y = 0
$postion.X = 0
$host.UI.RawUI.CursorPosition = $postion

clear_screen
print_status
print_menu

write-host "$E[?12l" -nonewline

while ($true) {
	$key = [System.Console]::ReadKey($true)
	switch ($key.Key) {
		q {
			clear_screen 
			write-host "$E[?12h" -nonewline
			exit
		}
		d {
			print "$E[38;2;${R};${G};${B}m$Brush$E[0m$E[1D"
		}
		e {
			print "$E[30m$defBrush$E[0m"
			print "$E[1D"
		}
		a {
			$yn = prompt a
			if ("y*" -like $yn) {
				clear_screen
				print_status
				print_menu
			}
		}
		c {
			$color = (prompt c).Split(",")
			$R = $color[0]
			$G = $color[1]
			$B = $color[2]
		}
		b {
			$Brush = prompt b
		}
		o {
			load_file (prompt o)
			print_menu
		}
		s {
			save_file (prompt s)
		}
		LeftArrow {
			print "$E[1D"
		}
		RightArrow {
			print "$E[1C"
		}
		DownArrow {
			if (($host.UI.RawUI.CursorPosition.Y) -lt (($host.UI.RawUI.WindowSize.Height) - 3)) { 
				print "$E[1B"
			}
		}
		UpArrow {
			if (($host.UI.RawUI.CursorPosition.Y) -gt ((1))) { 
				print "$E[1A"
			}
		}
	}
}
