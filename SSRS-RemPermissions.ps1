#Created by EGGSTOASTBACON :: https://github.com/eggstoastbacon
#Function for adding Users to Power-Bi Report Server, SSRS, Reporting Services
#Must be run from somewhere that has access to your report services website
#Usage: SSRS-remPermissions -User "$user" -folder "$path"
#Important! Modify the groups in this script to your match your environment first

function SSRS-remPermissions {

    param ([string]$user, [string]$folder)
    
    Clear-variable policy –erroraction silentlycontinue
    Clear-variable policies –erroraction silentlycontinue
    
    $domain = "DOMAIN"
    $password = Get-Content D:\YOUR\ENC\PASSWORD.ENC | ConvertTo-SecureString
    $LogonUser = "username"
    $URL = "http://localhost:80/ReportServer"
    $ReportServerUri = "$URL/ReportService2010.asmx"
    $Proxy = New-WebServiceProxy -Uri $ReportServerUri
    $Proxy.CookieContainer = New-Object System.Net.CookieContainer(10);
    $Proxy.LogonUser("$ogonUser", "$password", "$domain")
    
    if ($folder) {
        $folder = $folder 
    }
    else { write-host "Specify Folder" }
    
    $input_user = $user
    $InheritParent = $true
    
    $type = $proxy.GetType().Namespace;
    $policies = @()
    $policyType = "{0}.Policy" -f $type;
    $roleType = "{0}.Role" -f $type;
    
    $permissions = $proxy.getpolicies($folder, [ref]$InheritParent)
    
    if ($user -in $permissions.GroupUserName) {
    
        foreach ($permission in $permissions) {
    
            if ($permission.GroupUserName -notlike "*$User*") {
    
                $Policy = New-Object ($policyType)
            
                clear-variable a -ErrorAction SilentlyContinue
                clear-variable b -ErrorAction SilentlyContinue
                clear-variable c -ErrorAction SilentlyContinue
                clear-variable d -ErrorAction SilentlyContinue
                clear-variable e -ErrorAction SilentlyContinue
                clear-variable f -ErrorAction SilentlyContinue
            
                $Policy.GroupUserName = $permission.GroupUserName
    
                $a = New-Object ($roleType)
                $b = New-Object ($roleType)
                $c = New-Object ($roleType)
                $d = New-Object ($roleType)
                $e = New-Object ($roleType)
                $f = New-Object ($roleType)
            
                if ($permission.roles.name -like "*Content*") {
                    $a.Name = 'Content Manager'
                    $Policy.Roles += $a
                }
    
                if ($permission.roles.name -like "*Browser*") {
                    $b.Name = 'Browser'
                    $Policy.Roles += $b
                }
    
    
                if ($permission.roles.name -like "*My*") {
                    $c.Name = 'My Reports'
                    $Policy.Roles += $c
                }
    
                if ($permission.roles.name -like "*Pub*") {
                    $d.Name = 'Publisher'
                    $Policy.Roles += $d
                }
    
                if ($permission.roles.name -like "*Report*") {
                    $e.Name = 'Report Builder'
                    $Policy.Roles += $e
                }
    
                if ($permission.roles.name -like "*MSBI*") {
                    $f.Name = 'MSBI_Developers_Role'
                    $Policy.Roles += $f
                }
                $policies += $policy
            }
        } 
    
        $Proxy.SetPolicies("$folder", $policies); 
    }
}
    
