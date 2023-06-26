[![pongologo](./quicklog-logo.svg)](https://gitlab.snowlab.tk/powershell/quicklog/-/blob/main/quicklog-logo.svg)
--
[![Maintainer](https://img.shields.io/badge/Maintainer-mnoxx-blue??&stype=flat&logo=Personio&logoColor=blue)](https://gitlab.snowlab.tk/mnoxx)
[![License](https://img.shields.io/gitlab/license/43?gitlab_url=https%3a%2f%2fgitlab.snowlab.tk&logo=unlicense)](https://gitlab.snowlab.tk/powershell/quicklog/-/blob/main/LICENSE)
[![Latest Release](https://gitlab.snowlab.tk/powershell/quicklog/-/badges/release.svg)](https://gitlab.snowlab.tk/powershell/quicklog/-/releases) 
[![Pipeline Status](https://gitlab.snowlab.tk/powershell/quicklog/badges/main/pipeline.svg)](https://gitlab.snowlab.tk/powershell/quicklog/-/commits/main) 
[![Coverage Report](https://gitlab.snowlab.tk/powershell/quicklog/badgesmain/coverage.svg)](https://gitlab.snowlab.tk/powershell/quicklog/-/commits/main)
[![Contributors](https://img.shields.io/gitlab/contributors/powershell/quicklog?gitlab_url=https%3a%2f%2fgitlab.snowlab.tk)](https://gitlab.snowlab.tk/powershell/quicklog/activity)

# Quicklog
The `New-Quicklog` function is a PowerShell script that outputs a formatted log message to the console. The function has four parameters:

- `-name`: the name of the log message
- `-message`: the log message text
- `-type: the type of log message, which can be one of the following values: **"success"**, "**error"**, **"info"**, **"complete"**, or **"action"**
- `-unicode`: the unicode value of the symbol to be used in the log message

The function first splits the $message parameter into an array of sub-messages, if $message contains the string `@{pt:{`. If not, the `$message_exploded` variable is set to `$null`.

The script then sets the following variables to store the unicode values for different types of log messages:

- `$unicodeError: "#1F6A9"`
- `$unicodeSuccess: "#2705"`
- `$unicodeInfo: "#1FAA7"`
- `$unicodeComplete: "#1F375"`
- `$unicodeAction: "#1F528"`

The `$date` variable is set to the current date and time using the `get-date` cmdlet.

The script then outputs the log message to the console using a combination of the `write-host` cmdlet and `[powerunicode]::printByUnicode` method. The log message consists of the following elements:

- The square bracket `[` symbol with a yellow foreground color
- The symbol specified by the `$unicode` parameter using `[powerunicode]::printByUnicode($unicode)`
- The `$name` parameter with a magenta foreground color
- The square bracket `]` symbol with a yellow foreground color
- The log message type symbol specified by the `$type` parameter using `[powerunicode]::printByUnicode` and the corresponding `$unicodeXXX` variable. The symbol is displayed with a different foreground color depending on the type of log message.
- The log message area displays the `$message` parameter, or each sub-message in the `$message_exploded` array if it exists. If a sub-message starts with `{pt:{`, it is processed as a set of properties, and each property name-value pair is displayed on a separate line. If a sub-message doesn't start with `{pt:{`, it is displayed as is. If the `$type` parameter is "error", the log message or sub-message is displayed with a red background color.

Finally, the script outputs the log message type and the elapsed time since the log message was created using `get-elapsed` method. The elapsed time is displayed in a different foreground color depending on the type of log message.

The `new-quicklogsub` function is not used in the script and is defined but empty. An example call to the `new-quicklog` function is provided at the end of the script, which logs a "success" message with the name "Pongo" and the message text "Generating Pongo SVG Image".
