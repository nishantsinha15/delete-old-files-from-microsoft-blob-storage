Param(
  [string]$name,
  [string]$key,
  [string]$cname
)
Function deleteBasic
{
    Param($StorageAccountName, $StorageAccountKey, $ContainerNameArray)
    $ctx = New-AzureStorageContext -StorageAccountName $StorageAccountName ` -StorageAccountKey $StorageAccountKey
    foreach ( $ContainerName in $ContainerNameArray )
    {
        Write-Host $StorageAccountName $StorageAccountKey $ContainerName
        #date and time variable
        $DateandTime = Get-Date -Format o | foreach {$_ -replace ":", "-"}
        $DateandTime = $DateandTime -replace "T","-t-"
        # to delete directly from existing container
        $filelist = Get-AzureStorageBlob -Container $ContainerName -Context $ctx
        foreach ($file in $filelist | Where-Object {$_.LastModified.DateTime -lt ((Get-Date).AddMinutes(-1))}) #delete files older than 1 hour
        {
            $removefile = $file.Name
			if ($removefile -ne $null)
			{
				Write-Host "Removing file $removefile"
				Write-Host $file.LastModified.DateTime
				# Remove-AzureStorageBlob -Blob $removeFile -Container $ContainerName -Context $ctx
			}
        }
    }
}

$StorageAccountNameArray = $name.Split(",")
$StorageAccountKeyArray = $key.Split(",")
$ContainerNameArray1 = $cname.Split(",")

For ( $i=0; $i -lt $StorageAccountNameArray.Length; $i++ )
{
    Write-Host 'Epoch ' $i
    Write-Host 'Name =' $StorageAccountNameArray[$i] 'Key =' $StorageAccountKeyArray[$i] 'cname =' $ContainerNameArray1[$i].Split(" ")
    deleteBasic $StorageAccountNameArray[$i] $StorageAccountKeyArray[$i] $ContainerNameArray1[$i].Split(" ")
}
