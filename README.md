# powershell-inciga2
Powershell scripts to send info the the icinga2 server via the API

This will basically allow a windows server to send passive notifications to an icinga2 monitoring host.
Create an scheduled task to run the command. The task can be triggered or run periodically.

window_backup_control.ps1
-------------------------

This will query the latest state from Get-WBSummary  and send the information to icinga2 API.
