# powershell-inciga2
Powershell scripts to send info the the icinga2 server via the API

This will basically allow a windows server to send passive notifications to an icinga2 monitoring host.
Create an scheduled task to run the command. The task can be triggered or run periodically.

window_backup_control.ps1
-------------------------

This will query the latest state from Get-WBSummary  and send the information to icinga2 API.

Replace the variables on top of the script.

The username and password are configured on the icinga2 Server or satellite server.
```
$user = 'root'
$pass = 'icinga'
```

It needs to match to the configuration on the Icinga2 server.
The configuration on the Icinga2 server can be locate in the file below.

```
cat /etc/icinga2/conf.d/api-users.conf
/**
 * The APIUser objects are used for authentication against the API.
 */
object ApiUser "root" {
  password = "icinga"


  permissions = [ "*" ]
}
```

The variable icinga_host_port needs to point to the servername and port where Icinga2 host or satellite is running.

```
$icinga_host_port = "myicingaserver:5665"
```

The variable local_host needs the match the configuration of the Localhost name known to icinga2
```
$local_host = 'mylocalhostname'
```

The service variable will indicate the service name used in icinga2

```
$service = 'sysbackup'
```
