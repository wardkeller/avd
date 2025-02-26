$FolderName = 'Lawmaster'

$TempPath = $env:TEMP
$TempFolder = "$TempPath\$FolderName"
$ProgressPreference = 'SilentlyContinue'

new-item -name "$FolderName" -Path "$TempPath" -ItemType Directory -Force

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
    if ($install.ExitCode -ne 0) { throw "error installing $($_.OutFile)!"}
}

exit 0