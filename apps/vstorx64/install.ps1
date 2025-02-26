$FolderName = 'VSTORx64'

$TempPath = $env:TEMP
$TempFolder = "$TempPath\$FolderName"
$ProgressPreference = 'SilentlyContinue'

new-item -name "$FolderName" -Path "$TempPath" -ItemType Directory -Force

$VSTOR40 = @{
    Uri = 'https://download.microsoft.com/download/5/d/2/5d24f8f8-efbb-4b63-aa33-3785e3104713/vstor_redist.exe'
    OutFile = "$TempFolder\vstor_redist.exe"
}

Invoke-WebRequest @VSTOR40

$install = Start-Process $VSTOR40.OutFile -ArgumentList '/q','/norestart' -PassThru -Wait -NoNewWindow

if (($install.ExitCode -ne 0) -and ($install.ExitCode -ne 3010)) {
    throw 'vsto redistributable installation failed!'
}

$products = Get-CimInstance Win32_Product | Where-Object { $_.IdentifyingNumber -eq '{610487D9-3460-328A-9333-219D43A75CC5}' }
if ($products.length -eq 0) { throw 'vsto redistributable not installed!' }

exit 0