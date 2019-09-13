Import-Module downloader
Import-Module unzip

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stableVersion=$lwpm.version
$preVersion=$lwpm.preVersion
$githubRepo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description
$url=$lwpm.url
$preUrl=$lwpm.preUrl

Function getVersion($url){
  try{
    Invoke-WebRequest `
      -MaximumRedirection 0 `
      -Method Head `
      -uri $url
    }catch{
      $location = $_.Exception.Response.Headers.Location
      $url=$location.AbsoluteUri
      $version=$location.Segments[3].split('-')[2].trim('.exe')
    }

    return $version,$url
}

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION,$url=getVersion $url
  }

  if($isPre){
    $VERSION,$url=getVersion $preUrl
  }

  $filename="VSCodeUserSetup-x64-${VERSION}.exe"
  $unzipDesc="vscode"

  if($(_command code)){
    $CURRENT_VERSION=(code --version)[0]

    if ($CURRENT_VERSION -eq $VERSION){
        echo "==> $name $VERSION already install"
        return
    }
  }

  # 下载原始 zip 文件，若存在则不再进行下载
  _downloader `
    $url `
    $filename `
    $name `
    $VERSION

  # 验证原始 zip 文件 Fix me

  # 解压 zip 文件 Fix me
  # _unzip $filename $unzipDesc
  # 安装 Fix me
  # Copy-item "" ""

  Start-Process -FilePath $filename -wait

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  code --version
}

Function uninstall(){
  echo ""
  # Remove-item
}

Function getInfo(){
  $latestVersion=(getVersion $url)[0]
  $latestPreVersion=(getVersion $preUrl)[0]

  ConvertFrom-Json -InputObject @"
{
"Package": "$name",
"Version": "$stableVersion",
"PreVersion": "$preVersion",
"LatestVersion": "$latestVersion",
"LatestPreVersion": "$latestPreVersion",
"HomePage": "$homepage",
"Releases": "$releases",
"Bugs": "$bug",
"Description": "$description"
}
"@
}

Function bug(){
  return $bug
}

Function homepage(){
  return $homepage
}

Function releases(){
  return $releases
}
