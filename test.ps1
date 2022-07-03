#config
$dest_dir = "./temp"
mkdir $dest_dir -ErrorAction Ignore

#setup
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.66 Safari/537.36 Edg/103.0.1264.44"

#get download url
$datomatic_download_page = Invoke-WebRequest -UseBasicParsing -Uri "https://datomatic.no-intro.org/index.php?page=download&s=64&op=daily" `
  -Method "POST" `
  -WebSession $session `
  -ContentType "application/x-www-form-urlencoded" `
  -Body "dat_type=standard&goooo=Prepare" `
  -MaximumRedirection 0 `
  -ErrorAction Ignore `
  -Headers @{
  "authority"       = "datomatic.no-intro.org"
  "method"          = "POST"
  "path"            = "/index.php?page=download&s=64&op=daily"
  "scheme"          = "https"
  "accept"          = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
  "accept-encoding" = "gzip, deflate, br"
  "cache-control"   = "max-age=0"
  "dnt"             = "1"
  "origin"          = "https://datomatic.no-intro.org"
  "referer"         = "https://datomatic.no-intro.org/index.php?page=download&s=64&op=daily"
}
$cookie_data = $datomatic_download_page.Headers.'Set-Cookie' -split ';' -match 'PHPSESSID.+' -split '='
$session.Cookies.Add((New-Object System.Net.Cookie($cookie_data[0], $cookie_data[1], "/", "datomatic.no-intro.org")))
$datomatic_download_page.RawContent -match "Location: (.+)"
$datomatic_download_path = $Matches[1]

# Download daily file
$ProgressPreference = 'SilentlyContinue'
$nointro_download_url = "https://datomatic.no-intro.org/{0}" -f $datomatic_download_path
$nointro_download_dest = "{0}/no-intro.zip" -f $dest_dir
Invoke-WebRequest -UseBasicParsing -Uri $nointro_download_url `
  -Method "POST" `
  -WebSession $session `
  -ContentType "application/x-www-form-urlencoded" `
  -OutFile $nointro_download_dest `
  -Body "lazy_mode=Download" `
  -Headers @{
  "authority"       = "datomatic.no-intro.org"
  "method"          = "POST"
  "path"            = "/$datomatic_download_path"
  "scheme"          = "https"
  "accept"          = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
  "accept-encoding" = "gzip, deflate, br"
  "cache-control"   = "max-age=0"
  "dnt"             = "1"
  "origin"          = "https://datomatic.no-intro.org"
}

# REDUMP
$redump_baseurl = "http://redump.org"
$redump_download_page = Invoke-WebRequest -Uri "$redump_baseurl/downloads/"
$redump_download_list = $redump_download_page.Links | Where-Object { $_.innerText -match "Datfile" } | Where-Object { $_.innerText -notmatch "BIOS Datfile" } | Select-Object href | Where-Object { $_ }

#$bitstransfer_list = New-Object System.Collections.ArrayList
foreach ($link in $redump_download_list) {
  
  $source = $redump_baseurl + $link.href
  $destination = $dest_dir + "/" + ($link.href -split "/" | Where-Object { $_ } | Select-Object -Last 1) + ".zip"
  
  Invoke-WebRequest -UseBasicParsing -Uri "$source" `
    -OutFile "$destination" `
    -Headers @{
    "Accept"          = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
    "Accept-Encoding" = "gzip, deflate"
  }    
}

#Extract dats from zips
$zipfiles = Get-ChildItem -Path $dest_dir | Where-Object {$_.Name -match ".+\.zip"}
foreach( $file in $zipfiles ) {
  Expand-Archive -LiteralPath $file.FullName -DestinationPath $file.DirectoryName
}

#Remove non dat files
$nodatfiles = Get-ChildItem -Path $dest_dir | Where-Object {$_.Name -notmatch ".+\.dat"}
foreach( $file in $nodatfiles ) {
  Remove-Item $file.FullName
}

#Rename dat files
$datfiles = Get-ChildItem -Path $dest_dir | Where-Object {$_.Name -match ".+\.dat"}
foreach( $file in $datfiles ) {
  $newname = $file.Name -replace '(.+) \(.+\.dat', '$1.dat'
  Rename-Item -Path $file.FullName -NewName $newname
}

#'John D. Smith' -replace '(\w+) (\w+)\. (\w+)', '$1.$2.$3@contoso.com'