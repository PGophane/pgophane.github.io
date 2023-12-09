if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) {
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
  }

  $webUrl  = "http://intranet.lsbu.ac.uk/procurement/"    
  $library = "Authority to Award Report"   

  #Local Folder to dump files
  $tempLocation = "D:\MigrationInputs\Authority to Award Report List Attachments"     

  $s = new-object Microsoft.SharePoint.SPSite($webUrl)    
  $w = $s.OpenWeb()         
  $l = $w.Lists[$library]    
  $items = $l.Items
  foreach ($listItem in $items)
  {
        Write-Host "Content: " $listItem.ID 
        $destinationfolder = $tempLocation + "\" + $listItem.ID          
          if (!(Test-Path -path $destinationfolder))        
          {            
             $dest = New-Item $destinationfolder -type directory          
          }

          foreach ($attachment in $listItem.Attachments)    
          {        
                $file  = $w.GetFile($listItem.Attachments.UrlPrefix + $attachment)        
                $bytes = $file.OpenBinary()                
                $path  = $destinationfolder + "\" + $attachment
                Write "Saving $path" 
                $fs = new-object System.IO.FileStream($path, "OpenOrCreate") 
                $fs.Write($bytes, 0 , $bytes.Length)    
                $fs.Close()    
          }
  }