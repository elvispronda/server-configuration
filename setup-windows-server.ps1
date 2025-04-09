## PowerShell Script for Real Windows Server Setup
# Set variables
$NewHostname = "MyWindowsServer"
$IPAddress = "192.168.1.100"
$Subnet = "255.255.255.0"
$Gateway = "192.168.1.1"
$DNSServers = "8.8.8.8","8.8.4.4"
$InterfaceAlias = (Get-NetAdapter | Where-Object {$_.Status -eq "Up"}).InterfaceAlias

# Rename computer
Rename-Computer -NewName $NewHostname -Force

# Set static IP
New-NetIPAddress -InterfaceAlias $InterfaceAlias -IPAddress $IPAddress -PrefixLength 24 -DefaultGateway $Gateway

# Set DNS servers
Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $DNSServers

# Enable Remote Desktop
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Install server roles
Install-WindowsFeature -Name Web-Server, DNS, File-Services -IncludeManagementTools

# Enable automatic updates
Set-Service -Name wuauserv -StartupType Automatic
Start-Service -Name wuauserv
sconfig

# Restart to apply changes
Restart-Computer -Force

## HOW TO RUN SCRIPT
##Open PowerShell as Administrator
##Paste this to allow script execution temporarily:

## Set-ExecutionPolicy RemoteSigned -Scope Process

## RUN THE SCRIPT
## .\setup-windows-server.ps1



