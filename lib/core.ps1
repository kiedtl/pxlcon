function print($txt) {
	write-host $txt -nonewline
	$history.Add($txt)
}

function save_file($dest) {
	set-content $dest "$E[2J$E[2;H$(($history.ToArray()) -join '')$E[m$E[$(($host.UI.RawUI.WindowSize.Height)-3);H" -encoding UTF8
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
	write-host " [$E[38;2;255;255;255mc$E[0m]olor: ${R},${G},${B}, [$E[38;2;255;255;255mb$E[0m]rush: $Brush" -nonewline
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
	write-host "$E[$(($host.UI.RawUI.WindowSize.Height)-3);H$E[J$E[u" -nonewline
	# status_line

	print_status
	print_menu
	write-host "$E[s" -nonewline
	return $r
}

function clear_screen() {
	cls
	# write-host '$E[2J$E[2;H$E[m' -nonewline
	$history = New-Object System.Collections.Generic.List[string]
	$Brush = $defBrush
	$R = "255"
	$G = "255"
	$B = "255"
}
