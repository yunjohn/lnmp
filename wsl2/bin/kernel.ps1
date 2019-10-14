if($args.Length -eq 0){
  "WSL2 kernel download/update tool

You MUST edit $HOME\.wslconfig to custom kernel path, please see $HOME\lnmp\wsl2\conf\.wslconfig

COMMAND:

download  download kernel [ url ]
update    update kernel(Expand Archive kernel files to WSL2)

"

exit
}

$artifacts="https://github.com/khs1994/WSL2-Linux-Kernel/suites/263673284/artifacts/121226"
$kernelversion="wsl2-kernel-4.19.79-microsoft-standard+"
$zip="$home\Downloads\$kernelversion.zip"
$unzipFolder="$home\Downloads\$kernelversion"

# 下载文件

Function _downloader(){
  if (Test-Path $zip){
    "==> $zip exists, skip download"

    return
  }
  "==> download $zip"
  curl.exe -fL $artifacts -o $zip
}

_downloader

# 解压
if (Test-Path $unzipFolder){
  "==> $unzipFolder exists, skip unzip"
}else{
  Expand-Archive -Path $zip -DestinationPath $home/Downloads -Force
}

if ($args[0] -eq 'download'){
  exit
}

# 复制文件
$source=PWD
cd "$home\Downloads\$kernelversion"

"==> Exec: cp wsl2Kernel $home"

try{
  cp -r -Force wsl2Kernel $home

  $command="tar -zxvf linux.tar.gz -C /"

  "==> Exec: $command"

  wsl -u root -- bash -c $command
  cd $source
}catch {
  Write-Warning $_
  "==> wsl2 is running, please shutdown wsl( $ wsl --shutdown ),then rerun"
  cd $source
}
