#Created by EGGSTOASTBACON :: https://github.com/eggstoastbacon
#Function for adding Users to Power-Bi Report Server, SSRS, Reporting Services
#Must be run from somewhere that has access to your report services website
#Usage: SSRS-setPermissions -user "$User" -folder "$path" -roles "browser,report" -forceinherit $true/$false

function SSRS-setPermissions {

    param ([string]$user, [string]$folder, [string]$roles, [string]$forceinherit)
    Clear-variable policy –erroraction silentlycontinue
    Clear-variable policies –erroraction silentlycontinue

    $domain = "DOMAIN"
    $password = Get-Content D:\YOUR\ENC\PASSWORD.ENC | ConvertTo-SecureString
    $LogonUser = "username@someplace.org"
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
    $input_role = $roles
    $InheritParent = $forceinherit
    $Content_Manager = "False"
    $Browser = "False"
    $My_Reports = "False"
    $Publisher = "False"
    $Report_Builder = "False"
    $MSBI_Developers_Role = "False"
    
    if ($input_role) {
        if ($input_role -like "*Content*") {
            $Content_Manager = "True" 
        }
        if ($input_role -like "*Browser*") {
            $Browser = "True" 
        }
        if ($input_role -like "*My*") {
            $My_Reports = "True" 
        }
        if ($input_role -like "*Pub*") {
            $Publisher = "True" 
        }
        if ($input_role -like "*Report*") {
            $Report_Builder = "True" 
        }
        if ($input_role -like "*MSBI*") {
            $MSBI_Developers_Role = "True" 
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
        $e = New-Object ($roleType)
        $f = New-Object ($roleType)
            
        if ($Content_Manager -eq "True") {
            $a.Name = 'Content Manager'
            $Policy.Roles += $a
        }
    
        if ($Browser -like "True") {
            $b.Name = 'Browser'
            $Policy.Roles += $b
        }
    
        if ($My_Reports -like "*True") {
            $c.Name = 'My Reports'
            $Policy.Roles += $c
        }
    
        if ($Publisher -like "True") {
            $d.Name = 'Publisher'
            $Policy.Roles += $d
        }
    
        if ($Report_Builder -like "True") {
            $e.Name = 'Report Builder'
            $Policy.Roles += $e
        }
        if ($MSBI_Developers_Role -like "True") {
            $f.Name = 'MSBI_Developers_Role'
            $Policy.Roles += $f
        }
    
        $policies += $policy
    
    }
    
    else { write-host "Specify username" }
    
    $permissions = $proxy.getpolicies($folder, [ref]$InheritParent)
    
    
    
    foreach ($permission in $permissions) {
    
    
    
        $Policy = New-Object ($policyType)
    
            
        clear-variable a -ErrorAction SilentlyContinue
        clear-variable b -ErrorAction SilentlyContinue
        clear-variable c -ErrorAction SilentlyContinue
        clear-variable d -ErrorAction SilentlyContinue
        clear-variable e -ErrorAction SilentlyContinue
        clear-variable f -ErrorAction SilentlyContinue
    
        if ($permission.GroupUserName -notlike "*$User*") {
            
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
    if ($forceinherit -like "Yes") {
    
        write-host "Inherited!"
    
        $childitems = $Proxy.ListChildren($folder, $True)
    
        foreach ($children in $childitems) {
    
            $childpath = $children.path
    
            $childpath
    
            $Proxy.SetPolicies("$childpath", $policies); 
    
        }
    
    }
    else {
    
        $Proxy.SetPolicies("$folder", $policies); 
    
    }
            
}
