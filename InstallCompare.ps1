$Script = {

    			# Mssql 2014 Standard
                Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
                $DriveLetter = $(Get-Partition -DiskNumber 1 -PartitionNumber 2 | select DriveLetter -ExpandProperty DriveLetter)
    			$HOSTNAME=$(hostname)
    			$PackageName = "MsSqlServer2014Standard"
    			$Prerequisites = "Net-Framework-Core"
  				$silentArgs = "/IACCEPTSQLSERVERLICENSETERMS /Q /ACTION=install /FEATURES=SQLENGINE,REPLICATION,FULLTEXT,CONN,IS,BC,SDK,BOL,SSMS,ADV_SSMS /ASSYSADMINACCOUNTS=$HOSTNAME\Administrator /SQLSYSADMINACCOUNTS=$HOSTNAME\Administrator /INSTANCEID=MSSQLSERVER /INSTANCENAME=MSSQLSERVER /UPDATEENABLED=TRUE /INDICATEPROGRESS /TCPENABLED=1 /INSTALLSQLDATADIR=`"${DriveLetter}:\Microsoft SQL Server`""
				$validExitCodes = @(0)

         Sleep(30)
    		if ($Prerequisites){
        Install-WindowsFeature -IncludeAllSubFeature -ErrorAction Stop $Prerequisites
    			}

    $setupPath = "D:\setup.exe"

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


	}
$adminpassword = ConvertTo-SecureString -asPlainText -Force -String "@@{WINDOWS.secret}@@"
$Creds = New-Object System.Management.Automation.PSCredential("@@{WINDOWS.username}@@",$adminpassword)

Invoke-Command -ComputerName @@{address}@@ -Credential $Creds -ScriptBlock $script -Authentication Credssp
