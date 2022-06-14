$lhostname = [System.Net.Dns]::GetHostName()
$ldefaultgw = Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object -ExpandProperty "NextHop"
$l_osName = Get-ComputerInfo | select -expandproperty OsName 
$l_windowsProductName = Get-ComputerInfo | select -expandproperty WindowsProductName 
$l_windowsProductName = Get-ComputerInfo | select -expandproperty WindowsVersion
$l_osHardwareAbstractionLayer = Get-ComputerInfo | select -expandproperty OsHardwareAbstractionLayer
$l_osOsArchitecture = Get-ComputerInfo | select -expandproperty OsArchitecture
$l_osInstallDate = Get-ComputerInfo | select -expandproperty OsInstallDate
$l_csManufacturer = Get-ComputerInfo | select -expandproperty CsManufacturer
$l_csModel = Get-ComputerInfo | select -expandproperty CsModel
$l_csSystemType = Get-ComputerInfo | select -expandproperty CsSystemType
$l_timeZone = Get-ComputerInfo | select -expandproperty TimeZone
$l_osLanguage = Get-ComputerInfo | select -expandproperty OsLanguage
$l_osCountryCode = Get-ComputerInfo | select -expandproperty OsCountryCode
$l_osCurrentTimeZone = Get-ComputerInfo | select -expandproperty OsCurrentTimeZone
$l_osLocaleID = Get-ComputerInfo | select -expandproperty OsLocaleID
$l_osLocale = Get-ComputerInfo | select -expandproperty OsLocale
$l_csProcessors = Get-ComputerInfo | select -expandproperty CsProcessors
$l_csNumberOfLogicalProcessors = Get-ComputerInfo | select -expandproperty CsNumberOfLogicalProcessors
$l_NumberOfProcessors = Get-ComputerInfo | select -expandproperty CsNumberOfProcessors

#Splunk
$lhosts = "192.168.254.160:8089","inputs1.tpilatam.splunkcloud.com:9997","inputs2.tpilatam.splunkcloud.com:9997","inputs3.tpilatam.splunkcloud.com:9997","inputs4.tpilatam.splunkcloud.com:9997","inputs5.tpilatam.splunkcloud.com:9997","inputs6.tpilatam.splunkcloud.com:9997","inputs7.tpilatam.splunkcloud.com:9997","inputs8.tpilatam.splunkcloud.com:9997","inputs9.tpilatam.splunkcloud.com:9997","inputs10.tpilatam.splunkcloud.com:9997"
$Output = foreach ($lhost in $lhosts)
{
    $serviceName = Get-WmiObject -Class Win32_Product | where vendor -eq 'Splunk, Inc.' | where name -eq 'UniversalForwarder' | select Name, Vendor, Version, Caption
    if ($serviceName -eq $null){
        $isInstalled = "false"
    }
    else {
        $isInstalled = "true"
    }
    # Test All Connections for splunk
    if (Test-NetConnection -ComputerName $lhost.split(":")[0] -Port $lhost.split(":")[1] -InformationLevel Quiet -WarningAction SilentlyContinue)
    { 
        $isReachable = "true"
        $lapp = "splunk"
        Write-Host "Host $lhost port $lport is $isReachable"
    }
    else {
        $isReachable = "false"
        $lapp = "splunk"
        Write-Host "Host $lhost port $lport is $isReachable"
    }

        # Test All Connections for splunk
        if (Test-NetConnection -ComputerName $lhost.split(":")[0] -Port $lhost.split(":")[1] -InformationLevel Quiet -WarningAction SilentlyContinue)
        { 
            $isReachable = "true"
            $lapp = "splunk"
            Write-Host "Host $lhost port $lport is $isReachable"
        }
        else {
            $isReachable = "false"
            $lapp = "splunk"
            Write-Host "Host $lhost port $lport is $isReachable"
        }
        
    New-Object -TypeName PSObject -Property @{
        hostname = $lhostname
        address = $lhost.split(":")[0]
        port = $lhost.split(":")[1]
        app = $lapp
        installed = $isInstalled
        reachable = $isReachable 
    } | Select-Object hostname,address,port,app,installed,reachable
}

$Output | Export-Csv d:\scripts\data.csv

# Zabbix
$lhosts = "10.241.35.35:1050","10.241.35.35:10510","10.241.35.39:1050","10.241.35.39:10510","10.241.35.9:1050","10.241.35.9:10510"
$Output = foreach ($lhost in $lhosts)
{
    # Verify if zabbix agent is installed
    $serviceName = Get-Service | where Name -eq 'AJrouter' | select -expandproperty Name
    if ($serviceName -eq $null){
        $isInstalled = "false"
    }
    else {
        $isInstalled = "true"
    }
    # Test All Connections for Zabbix

    if (Test-NetConnection -ComputerName $lhost.split(":")[0] -Port $lhost.split(":")[1] -InformationLevel Quiet -WarningAction SilentlyContinue)
    { 
        $isReachable = "true"
        $lapp = "zabbix"
        Write-Host "Host $lhost port $lport is $isReachable"
    }
    else {
        $isReachable = "false"
        $lapp = "zabbix"
        Write-Host "Host $lhost port $lport is $isReachable"
    }
        
    New-Object -TypeName PSObject -Property @{
        hostname = $lhostname
        address = $lhost.split(":")[0]
        port = $lhost.split(":")[1]
        app = $lapp
        installed = $isInstalled
        reachable = $isReachable 
    } | Select-Object hostname,address,port,app,installed,reachable
}
$Output | Export-Csv -Append d:\scripts\data.csv

# Internet
$lhosts = "uol.com.br:443","google.com:443"
$Output = foreach ($lhost in $lhosts)
{
    # Test Direct Internet Connection
    if (Test-NetConnection -ComputerName $lhost.split(":")[0] -Port $lhost.split(":")[1] -InformationLevel Quiet -WarningAction SilentlyContinue)
    { 
        $isReachable = "true"
        $lapp = "internet"
        Write-Host "Host $lhost port $lport is $isReachable"
    }
    else {
        $isReachable = "false"
        $lapp = "internet"
        Write-Host "Host $lhost port $lport is $isReachable"
    }
        
    New-Object -TypeName PSObject -Property @{
        hostname = $lhostname
        address = $lhost.split(":")[0]
        port = $lhost.split(":")[1]
        app = $lapp
        installed = "n/a"
        reachable = $isReachable 
    } | Select-Object hostname,address,port,app,installed,reachable
}
$Output | Export-Csv -Append d:\scripts\data.csv

Write-output "Script has finished. Please check output files."
pause
