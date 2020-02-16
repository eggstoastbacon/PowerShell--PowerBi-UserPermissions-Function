#Created by EGGSTOASTBACON :: https://github.com/eggstoastbacon
#Function for adding Users to Power-Bi Report Server, SSRS, Reporting Services
#Must be run from somewhere that has access to your report services website
#Usage: SSRS-setSysPermissions -User "$user" -roles "User"
#Roles: admin, user, schedule, msbi
#Important! Modify the groups in this script to your match your environment first

function SSRS-setSysPermissions {

    param ([string]$user, [string]$roles)
    
    Clear-variable policy –erroraction silentlycontinue
    Clear-variable policies –erroraction silentlycontinue
    
    $domain = "DOMAIN"
    $password = Get-Content D:\YOUR\ENC\PASSWORD.ENC | ConvertTo-SecureString
    $LogonUser = "username"
    $URL = "http://localhost:80/ReportServer"
    $ReportServerUri = "$URL/ReportService2010.asmx"
    $Proxy = New-WebServiceProxy -Uri $ReportServerUri
    $Proxy.CookieContainer = New-Object System.Net.CookieContainer(10);
    $Proxy.LogonUser("$logonUser", "$password", "$domain")
    
    if ($folder) {
        $folder = "/" + $folder 
    }
    else { write-host "Specify Folder" }
    
    $input_user = $user
    $input_role = $roles
    $InheritParent = $true
    $System_Administrator = "False"
    $System_User = "False"
    $My_Reports = "False"
    $Schedules = "False"
    $MSBI_Developers_System_Role = "False"
    
    if ($input_role) {
        if ($input_role -like "*Admin*") {
            $System_Administrator = "True" 
        }
        if ($input_role -like "*User*") {
            $System_User = "True" 
        }
        if ($input_role -like "*Schedule*") {
            $Schedules = "True" 
        }
        if ($input_role -like "*MSBI*") {
            $MSBI_Developers_System_Role = "True" 
        }
    }
    
    else { write-host "Specify permissions" }
    
    
    $type = $Proxy.GetType().Namespace;
    $policies = @()
    $policyType = "{0}.Policy" -f $type;
    $roleType = "{0}.Role" -f $type;
       
    if ($user) {
    
        $Policy = New-Object ($policyType)
    
        $Policy.GroupUserName = $user 
    
        $a = New-Object ($roleType)
        $b = New-Object ($roleType)
        $c = New-Object ($roleType)
        $d = New-Object ($roleType)
    
            
        if ($System_Administrator -eq "True") {
            $a.Name = 'System Administrator'
            $Policy.Roles += $a
        }
    
        if ($System_User -like "True") {
            $b.Name = 'System User'
            $Policy.Roles += $b
        }
    
    
        if ($Schedules -like "True") {
            $c.Name = 'Schedules'
            $Policy.Roles += $c
        }
    
        if ($Schedules -like "True") {
            $d.Name = 'MSBI_Developers_System_Role'
            $Policy.Roles += $d
        }
      
        $policies += $policy
    
    }
    
    else { write-host "Specify username" }
    
    $permissions = $proxy.getSystempolicies()
    
    foreach ($permission in $permissions) {    
    
        $Policy = New-Object ($policyType)
            
        clear-variable a -ErrorAction SilentlyContinue
        clear-variable b -ErrorAction SilentlyContinue
        clear-variable c -ErrorAction SilentlyContinue
        clear-variable d -ErrorAction SilentlyContinue
        clear-variable e -ErrorAction SilentlyContinue
    
        if ($permission.GroupUserName -notlike "*$User*") {
            
            $Policy.GroupUserName = $permission.GroupUserName         
    
            $a = New-Object ($roleType)
            $b = New-Object ($roleType)
            $c = New-Object ($roleType)
            $d = New-Object ($roleType)    
            
            if ($permission.roles.name -like "*Admin*") {
                $a.Name = 'System Administrator'
                $Policy.Roles += $a
            }
    
            if ($permission.roles.name -like "*User*") {
                $b.Name = 'System User'
                $Policy.Roles += $b
            }
    
            if ($permission.roles.name -like "*Schedule*") {
                $c.Name = 'Schedules'
                $Policy.Roles += $c
            }
    
            if ($permission.roles.name -like "*MSBI*") {
                $d.Name = 'MSBI_Developers_System_Role'
                $Policy.Roles += $d
            }
    
            $policies += $policy
    
        } 
    }
    
    $Proxy.SetSystemPolicies($policies);     
}
