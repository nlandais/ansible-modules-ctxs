#!powershell
# This file is part of Ansible
#
# Copyright 2016, Citrix Systems, Inc <nicolas.landais@citrix.com>
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

# WANT_JSON
# POWERSHELL_COMMON
$ErrorActionPreference = "Stop"

$params = Parse-Args $args;
$result = New-Object PSObject;
Set-Attr $result "changed" $false;

# Check input parameters
$user = Get-Attr $params -name "user" -failifempty $true
$name = Get-Attr $params -name "name" -default $env:computername
$state = Get-Attr -obj $params -name "state" -default "present"
$domain = Get-Attr $params -name "domain" -failifempty $true
$password = Get-Attr $params -name "password" -failifempty $true
$reboot = Get-Attr $params -name "reboot" -default $false
$output = "$name has been successfully added to the $domain domain"
# Create PSCredential Object and un/join the domain
try {
    $encrypted_password = ConvertTo-SecureString $password -AsPlainText -Force
    $Credential = new-object -typename System.Management.Automation.PSCredential -argumentlist $user,$encrypted_password
    if (($state -eq "present") -and ($name -ne $env:computername)) {
           Add-Computer -NewName $name -Credential $Credential -DomainName $domain -Force
    } elseif  (($state -eq "present") -and ($name -eq $env:computername)) {
           Add-Computer -ComputerName $name -Credential $Credential -DomainName $domain -Force
    }
    if ($state -eq "absent") {
        Remove-Computer -ComputerName $name -UnjoinDomainCredential $Credential -Force
        $output = "$name has been successfully removed from the $domain domain"
    }
    if ($reboot -eq $true )
    {
        Restart-Computer -force
        $output = "$($output) and the computer has been successfully rebooted."
    }

    Set-Attr $result "name" $name;
    Set-Attr $result "domain" $domain
    Set-Attr $result "output" $output
    $result.changed = $true
} catch {
    $ErrorMessage = $_.Exception.Message
    Fail-Json $result "Error: $ErrorMessage"
}
Exit-Json $result;