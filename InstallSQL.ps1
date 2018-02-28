$Script = {

    			# Mssql 2014 Standard
                Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
                Start-Sleep -s 300
                $DriveLetter=([System.IO.DriveInfo]::GetDrives() | ?{$_.Drivetype -eq "CDROM" -and $_.Volumelabel -like "SQL*"}).name
    			$HOSTNAME=$(hostname)
    			$PackageName = "MsSqlServer2014Standard"

  				$silentArgs = "/IACCEPTSQLSERVERLICENSETERMS /Q /ACTION=install /FEATURES=SQLENGINE,REPLICATION,FULLTEXT,CONN,IS,BC,SDK,BOL,SSMS,ADV_SSMS /ASSYSADMINACCOUNTS=$HOSTNAME\Administrator /SQLSYSADMINACCOUNTS=$HOSTNAME\Administrator /INSTANCEID=MSSQLSERVER /INSTANCENAME=MSSQLSERVER /UPDATEENABLED=TRUE /INDICATEPROGRESS /TCPENABLED=1 /INSTALLSQLDATADIR=`"${DriveLetter}:\Microsoft SQL Server`""
				$validExitCodes = @(0)
    		}

    $setuppath=$driveletter + "setup.exe"

    Write-Output "Installing $PackageName...."

    $secpasswd = ConvertTo-SecureString "@@{WINDOWS.secret}@@" -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential("@@{WINDOWS.username}@@",$secpasswd)

    $install = Start-Process -FilePath $setupPath -ArgumentList $silentArgs -Wait -NoNewWindow -PassThru -Credential $credential
    $install.WaitForExit()

    $exitCode = $install.ExitCode
    $install.Dispose()
				Write-Output "Command [`"$setupPath`" $silentArgs] exited with `'$exitCode`'."
    		if ($validExitCodes -notcontains $exitCode)
			{
        	Write-Output "Running [`"$setupPath`" $silentArgs] was not successful. Exit code was '$exitCode'. See log for possible error messages."
     		}



$adminpassword = ConvertTo-SecureString -asPlainText -Force -String "@@{WINDOWS.secret}@@"
$Creds = New-Object System.Management.Automation.PSCredential("@@{WINDOWS.username}@@",$adminpassword)

Invoke-Command -ComputerName @@{address}@@ -Credential $Creds -ScriptBlock $script -Authentication Credssp
