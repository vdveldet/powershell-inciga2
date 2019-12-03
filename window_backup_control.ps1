$user = 'root'
$pass = 'icinga'
$icinga_host_port = "myicingaserver:5665"
$local_host = 'mylocalhostname'

add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$pair = "$($user):$($pass)"
$url = 'https://' + $icinga_host_port +'/v1/actions/process-check-result?service='+$local_host+'!sysbackup'

try {
    $lastbackupresulthr = Get-WBSummary |select -ExpandProperty lastbackupresulthr
    $LastBackupTime = Get-WBSummary | select -ExpandProperty LastBackupTime
    $LastSuccessfulBackupTargetLabel = Get-WBSummary | select -ExpandProperty LastSuccessfulBackupTargetLabel
    $NumberOfVersions = Get-WBSummary | select -ExpandProperty NumberOfVersions
} catch{
    $lastbackupresulthr = 2
    $LastBackupTime = 0
    $LastSuccessfulBackupTargetLabel = 0
    $NumberOfVersions = 0
}

$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $encodedCreds"
$Headers = @{
    Authorization = $basicAuthValue
    "accept"="application/json"}
$icinga_host = @{
exit_status= $lastbackupresulthr
plugin_output= "Last Backup Time : " + $LastBackupTime + " on " + $LastSuccessfulBackupTargetLabel + " number of versions " + $NumberOfVersions
performance_data= "version=" + $NumberOfVersions
}
$json = $icinga_host | ConvertTo-Json
$response = Invoke-RestMethod -Uri $url -Method Post -ContentType 'application/json' -Headers $Headers -Body $json
