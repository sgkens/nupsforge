# Set the console font to a Nerd font that supports icons
$fontFamily = "CaskaydiaCove NF"
#$fontSize = 14  # Adjust the font size as desired

# Configure the console font and size
$font = New-Object -TypeName System.Drawing.Font($fontFamily, $fontSize)
$console = [System.Console]
$console.GetType().GetProperty("Font").SetValue($console, $font, $null)

# Output Nerd font icon using its Unicode code point
$iconCodePoint = "F118"  # Replace with the desired code point
$icon = [char]::ConvertFromUtf32([Convert]::ToInt32($iconCodePoint, 16))
Write-Output "Nerd font icon: $icon"