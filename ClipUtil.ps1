param (
	[Parameter(Mandatory=$true, Position=0)]
	[string]$file
)

Add-Type -AssemblyName "System.Windows.Forms"
Add-Type -AssemblyName "PresentationCore"

$arr = Get-Content $file
$index = 0
$continue = $true
$pressed = $false

Write-Host "Update Clipboard with Num5. F12 to exit. F9 for previous option, F10 to advance."
Write-Host $arr[$index]

while($continue) {
	if(-NOT $pressed) {
		if ([System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::Clear)) {
			$pressed = $true
			$arr[$index] | clip 
			[System.Windows.Forms.SendKeys]::SendWait("^{v}")
			
			if($index+1 -eq $arr.length) { $continue = $false }
			else { Write-Host $arr[++$index] }
		}
		
		if ([System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::F9)) {
			$pressed = $true
			if ($index -gt 0) { $index-- }
			Write-Host $arr[$index]
		}
		
		if ([System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::F10)) {
			$pressed = $true
			if ($index+1 -ne $arr.length) { $index++ }
			Write-Host $arr[$index]
		}
	}
	if($pressed) {
		if ([System.Windows.Input.Keyboard]::IsKeyUp([System.Windows.Input.Key]::Clear) -OR [System.Windows.Input.Keyboard]::IsKeyUp([System.Windows.Input.Key]::F9) -OR [System.Windows.Input.Keyboard]::IsKeyUp([System.Windows.Input.Key]::F10)) {
				$pressed = $false
		}
	}
	if ([System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::F12)) { $continue = $false }
	sleep -milliseconds 100
}
