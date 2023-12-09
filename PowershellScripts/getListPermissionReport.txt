# SP 2010/2013
Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell
cls

$properties = @{List_Title='';Item_Url='';Member_Name='';Assigned_Permission='';}; 
$Items = @(); 


$web = Get-SPWeb "<Site URL>"

#$lists = $web.Lists
$list = $web.Lists["<List Name>"]
#   foreach($list in $lists)
 #  {
        if($list.HasUniqueRoleAssignments)
        {
            $ListRoles = $list.RoleAssignments
            foreach($listRole in $ListRoles)
                {
            
                    $ListRoleBindings = $listrole.RoleDefinitionBindings
                    foreach($ListRoleBinding in $ListRoleBindings)
                    {               

                    if($listrole.Member.IsDomainGroup -eq $null)
                    {
                     if($ListRoleBinding.Name -ne "Limited Access")
                         {
                            $details = New-Object -TypeName PSObject -Property $properties;  
                            $details.List_Title = $list.Title
                            $details.Item_Url = ""
                            $details.Member_Name = $ListRole.Member.Name  
                            $details.Assigned_Permission = $ListRoleBinding.Name
                            $Items +=$details;
                        }
                         
                    }
                    else
                    {
                        if($listrole.Member.IsDomainGroup)
                        {
                            if($ListRoleBinding.Name -ne "Limited Access")
                            {
                            $details = New-Object -TypeName PSObject -Property $properties;  
                            $details.List_Title = $list.Title
                            $details.Item_Url = ""
                            $details.Member_Name = $ListRole.Member.Name  
                            $details.Assigned_Permission = $ListRoleBinding.Name
                            $Items +=$details;
                            }
                        
                        }
                        else
                        
                        {
                            if($ListRoleBinding.Name -ne "Limited Access")
                            {
                            $details = New-Object -TypeName PSObject -Property $properties;  
                            $details.List_Title = $list.Title
                            $details.Item_Url = ""
                            $details.Member_Name = $ListRole.Member.UserLogin  
                            $details.Assigned_Permission = $ListRoleBinding.Name
                            $Items +=$details;
                            }
                        
                        }
                    }

   
                    }
            
                }

        }

       

        $Uniqueitems = $list.GetItemsWithUniquePermissions()
            foreach($Uniqueitem in $Uniqueitems)
            {

                $item = $list.GetItemById($Uniqueitem.id)
                $itemRoles = $item.RoleAssignments
                foreach($itemRole in $itemroles)
                    {
                    $itemRoleBindings = $itemrole.RoleDefinitionBindings
                    foreach($itemrolebinding in $itemRoleBindings)
                        {
                        

                    if ($itemrole.Member.IsDomainGroup -eq $null)
                    {
                        if($itemRoleBinding.Name -ne "Limited Access")
                        {
                        $details = New-Object -TypeName PSObject -Property $properties;  
                        $details.List_Title = $list.Title
                        $details.Item_Url = $rooturl+ "/" +$item.Url
                        $details.Member_Name = $itemrole.Member.Name  
                        $details.Assigned_Permission = $itemRoleBinding.Name
                        $Items +=$details;
                        }
                                        
                    }
                    else
                    {
                        if($itemrole.Member.IsDomainGroup)
                        {
                            if($itemRoleBinding.Name -ne "Limited Access")
                            {
                            $details = New-Object -TypeName PSObject -Property $properties;  
                            $details.List_Title = $list.Title
                            $details.Item_Url = $rooturl+ "/" +$item.Url
                            $details.Member_Name = $itemrole.Member.Name  
                            $details.Assigned_Permission = $itemRoleBinding.Name
                            $Items +=$details;
                            }
                        
                        }
                        else
                        
                        {
                            if($itemRoleBinding.Name -ne "Limited Access")
                            {
                            $details = New-Object -TypeName PSObject -Property $properties;  
                            $details.List_Title = $list.Title
                            $details.Item_Url = $rooturl+ "/" +$item.Url
                            $details.Member_Name = $itemrole.Member.UserLogin  
                            $details.Assigned_Permission = $itemRoleBinding.Name
                            $Items +=$details;
                            }

                        }
                    }


     }
                    }

            }

#   }

$web.Dispose()
$reportPath = "D:\Powershell\List_Permissions.csv"
$Items | select List_Title,Item_Url,Member_Name,Assigned_Permission | Export-csv $reportPath -NoTypeInformation;

write-host "DONE!!!!"
