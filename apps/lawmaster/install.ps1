$TempPath = $env:TEMP
$TempFolder = "$TempPath\Lawmaster"

new-item -name "Lawmaster" -Path $TempPath -ItemType Directory -Force


$VSTOR40 = @{
    Uri = 'https://download.microsoft.com/download/5/d/2/5d24f8f8-efbb-4b63-aa33-3785e3104713/vstor_redist.exe'
    OutFile = "$TempFolder\vstor_redist.exe"
}

Invoke-WebRequest @VSTOR40

$install = Start-Process "$VSTOR40.OutFile" -ArgumentList '/q','/norestart' -PassThru -Wait -NoNewWindow

if ($install.ExitCode -ne 1) { throw 'error installing vsto redistributable!'}

@(
    @{
        Component = 'ClientStartup'
        Uri     = 'https://members.lawmaster.com.au/members/downloads/10.15.4068/LawMaster%20Client%20Startup%20v10.15.4068.msi'
        OutFile = "$TempFolder\Lawmaster Client Startup v10.15.4068.msi"
    },
    @{
        Component = 'OutlookAddin'
        Uri     = 'https://members.lawmaster.com.au/members/downloads/10.15.4068/LawMaster%20Outlook%20AddIn%20v10.15.4068.msi'
        OutFile = "$TempFolder\Lawmaster Outlook AddIn v10.15.4068.msi"
    },
    @{
        Component = 'PracticeManagementClient'
        Uri     = 'https://members.lawmaster.com.au/members/downloads/10.15.4068/PracticeManagement%20Client%20v10.15.4068.msi'
        OutFile = "$TempFolder\PracticeManagement Client v10.15.4068.msi"
    }
 ) | ForEach-Object {
    Invoke-WebRequest -UseBasicParsing -Uri $_.Uri -OutFile $_.OutFile
    $install = Start-Process 'msiexec.exe' -ArgumentList '/i',"$($_.OutFile)","/qn" -Wait -PassThru -NoNewWindow
    if ($install.ExitCode -ne 1) { throw "error installing $($_.OutFile)!"}
}

