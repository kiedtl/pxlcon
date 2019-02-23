. "$psscriptroot\lib\core.ps1"

$E = [char]27
$R = "255"
$G = "255"
$B = "255"

$Brush = [text.encoding]::utf8.getstring((226,150,136))
$defBrush = [text.encoding]::utf8.getstring((226,150,136))
$history = New-Object System.Collections.Generic.List[string]

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
