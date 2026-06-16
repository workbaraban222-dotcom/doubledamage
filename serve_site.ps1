$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$log = Join-Path $root "serve_site_ps.log"
"boot $((Get-Date).ToString('s')) root=$root" | Out-File -LiteralPath $log -Append -Encoding utf8
Set-Location -LiteralPath $root

$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Parse("127.0.0.1"), 4173)
$listener.Start()
"listening" | Out-File -LiteralPath $log -Append -Encoding utf8
"DOUBLE DAMAGE site: http://127.0.0.1:4173/index.html"

$types = @{
  ".html" = "text/html; charset=utf-8"
  ".css" = "text/css; charset=utf-8"
  ".js" = "application/javascript; charset=utf-8"
  ".png" = "image/png"
  ".jpg" = "image/jpeg"
  ".jpeg" = "image/jpeg"
  ".webp" = "image/webp"
  ".svg" = "image/svg+xml"
}

try {
  while ($true) {
    $client = $listener.AcceptTcpClient()
    try {
    $stream = $client.GetStream()
    $reader = [System.IO.StreamReader]::new($stream, [System.Text.Encoding]::ASCII, $false, 1024, $true)
    $requestLine = $reader.ReadLine()
    while (($line = $reader.ReadLine()) -ne $null -and $line -ne "") {}

    $target = "/index.html"
    if ($requestLine -match "^[A-Z]+\s+([^\s]+)") {
      $target = $matches[1].Split("?")[0]
      if ($target -eq "/") { $target = "/index.html" }
    }

    $relative = [Uri]::UnescapeDataString($target).TrimStart("/")
    $file = [System.IO.Path]::GetFullPath((Join-Path $root $relative))
    $rootFull = [System.IO.Path]::GetFullPath($root)

    if (-not $file.StartsWith($rootFull)) {
      $body = [System.Text.Encoding]::UTF8.GetBytes("Forbidden")
      $header = "HTTP/1.1 403 Forbidden`r`nContent-Length: $($body.Length)`r`nConnection: close`r`n`r`n"
      $bytes = [System.Text.Encoding]::ASCII.GetBytes($header)
      $stream.Write($bytes, 0, $bytes.Length)
      $stream.Write($body, 0, $body.Length)
      continue
    }

    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
      $body = [System.Text.Encoding]::UTF8.GetBytes("Not found")
      $header = "HTTP/1.1 404 Not Found`r`nContent-Length: $($body.Length)`r`nConnection: close`r`n`r`n"
      $bytes = [System.Text.Encoding]::ASCII.GetBytes($header)
      $stream.Write($bytes, 0, $bytes.Length)
      $stream.Write($body, 0, $body.Length)
      continue
    }

    $body = [System.IO.File]::ReadAllBytes($file)
    $ext = [System.IO.Path]::GetExtension($file).ToLowerInvariant()
    $type = if ($types.ContainsKey($ext)) { $types[$ext] } else { "application/octet-stream" }
    $header = "HTTP/1.1 200 OK`r`nContent-Type: $type`r`nContent-Length: $($body.Length)`r`nConnection: close`r`n`r`n"
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($header)
    $stream.Write($bytes, 0, $bytes.Length)
    $stream.Write($body, 0, $body.Length)
    } finally {
      $client.Close()
    }
  }
} catch {
  "fatal $($_.Exception.Message)" | Out-File -LiteralPath $log -Append -Encoding utf8
  throw
}
