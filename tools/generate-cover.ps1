Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$outDir = Join-Path $root "assets"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$width = 1600
$height = 2400
$bitmap = New-Object System.Drawing.Bitmap $width, $height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

function Brush($r, $g, $b, $a = 255) {
  return New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb($a, $r, $g, $b))
}

function Pen($r, $g, $b, $a = 255, $w = 1) {
  return New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb($a, $r, $g, $b), $w)
}

$rect = New-Object System.Drawing.Rectangle 0, 0, $width, $height
$bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect,
  ([System.Drawing.Color]::FromArgb(255, 8, 10, 12)),
  ([System.Drawing.Color]::FromArgb(255, 38, 6, 4)),
  90
$graphics.FillRectangle($bg, $rect)

# Smoky mine depth.
for ($i = 0; $i -lt 18; $i++) {
  $alpha = 18 + ($i % 5) * 4
  $y = 120 + $i * 118
  $brush = Brush 80 26 18 $alpha
  $graphics.FillEllipse($brush, -260 + ($i % 3) * 160, $y, 2100, 260)
  $brush.Dispose()
}

# Black well shaft.
$shaft = New-Object System.Drawing.Drawing2D.GraphicsPath
$shaftPoints = New-Object 'System.Drawing.Point[]' 4
$shaftPoints[0] = New-Object System.Drawing.Point 340, 430
$shaftPoints[1] = New-Object System.Drawing.Point 1260, 430
$shaftPoints[2] = New-Object System.Drawing.Point 1450, 2260
$shaftPoints[3] = New-Object System.Drawing.Point 150, 2260
$shaft.AddPolygon($shaftPoints)
$graphics.FillPath((Brush 3 4 5 205), $shaft)
$graphics.DrawPath((Pen 118 31 20 130 5), $shaft)

# Red spirit iron cracks.
$rand = New-Object System.Random 4242
for ($i = 0; $i -lt 44; $i++) {
  $x = $rand.Next(160, 1440)
  $y = $rand.Next(520, 2240)
  $len = $rand.Next(90, 260)
  $points = New-Object System.Collections.Generic.List[System.Drawing.Point]
  $points.Add((New-Object System.Drawing.Point $x, $y))
  $cx = $x
  $cy = $y
  for ($j = 0; $j -lt 4; $j++) {
    $cx += $rand.Next(-45, 46)
    $cy += [int]($len / 4)
    $points.Add((New-Object System.Drawing.Point $cx, $cy))
  }
  $penGlow = Pen 255 61 24 50 10
  $penCore = Pen 255 125 50 150 3
  $graphics.DrawLines($penGlow, $points.ToArray())
  $graphics.DrawLines($penCore, $points.ToArray())
  $penGlow.Dispose()
  $penCore.Dispose()
}

# Contract ledger slab.
$ledgerRect = New-Object System.Drawing.Rectangle 260, 990, 1080, 770
$ledgerBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $ledgerRect,
  ([System.Drawing.Color]::FromArgb(235, 42, 25, 18)),
  ([System.Drawing.Color]::FromArgb(235, 10, 8, 7)),
  20
$graphics.FillRectangle($ledgerBrush, $ledgerRect)
$graphics.DrawRectangle((Pen 206 76 36 150 4), $ledgerRect)

for ($i = 0; $i -lt 13; $i++) {
  $y = 1050 + $i * 48
  $graphics.DrawLine((Pen 184 72 38 80 2), 330, $y, 1260, $y + $rand.Next(-8, 9))
}
for ($i = 0; $i -lt 8; $i++) {
  $x = 420 + $i * 105
  $graphics.DrawLine((Pen 120 45 30 55 2), $x, 1030, $x + $rand.Next(-25, 25), 1710)
}

# Abacus beads / debt marks.
for ($row = 0; $row -lt 4; $row++) {
  for ($col = 0; $col -lt 9; $col++) {
    $x = 378 + $col * 92 + (($row % 2) * 24)
    $y = 1155 + $row * 98
    $graphics.FillEllipse((Brush 150 34 22 185), $x, $y, 42, 42)
    $graphics.FillEllipse((Brush 255 120 48 75), $x + 8, $y + 6, 15, 15)
  }
}

# Silhouette.
$cloak = New-Object System.Drawing.Drawing2D.GraphicsPath
$cloakPoints = New-Object 'System.Drawing.Point[]' 5
$cloakPoints[0] = New-Object System.Drawing.Point 800, 610
$cloakPoints[1] = New-Object System.Drawing.Point 1015, 965
$cloakPoints[2] = New-Object System.Drawing.Point 1180, 1770
$cloakPoints[3] = New-Object System.Drawing.Point 420, 1770
$cloakPoints[4] = New-Object System.Drawing.Point 585, 965
$cloak.AddPolygon($cloakPoints)
$graphics.FillPath((Brush 4 5 6 235), $cloak)
$graphics.DrawPath((Pen 205 57 29 100 3), $cloak)
$graphics.FillEllipse((Brush 5 5 6 245), 690, 470, 220, 250)

# Contract page in hand.
$paper = New-Object System.Drawing.Drawing2D.GraphicsPath
$paperPoints = New-Object 'System.Drawing.Point[]' 4
$paperPoints[0] = New-Object System.Drawing.Point 930, 890
$paperPoints[1] = New-Object System.Drawing.Point 1180, 940
$paperPoints[2] = New-Object System.Drawing.Point 1125, 1265
$paperPoints[3] = New-Object System.Drawing.Point 890, 1210
$paper.AddPolygon($paperPoints)
$graphics.FillPath((Brush 182 138 83 210), $paper)
$graphics.DrawPath((Pen 255 173 74 120 3), $paper)
for ($i = 0; $i -lt 5; $i++) {
  $graphics.DrawLine((Pen 70 22 15 130 3), 935, 965 + $i * 52, 1110, 1000 + $i * 48)
}

# Title.
$fontPath = "C:\Windows\Fonts\simhei.ttf"
$fontCollection = New-Object System.Drawing.Text.PrivateFontCollection
$fontCollection.AddFontFile($fontPath)
$fontFamily = $fontCollection.Families[0]
$titleFont = New-Object System.Drawing.Font $fontFamily, 128, ([System.Drawing.FontStyle]::Bold), ([System.Drawing.GraphicsUnit]::Pixel)
$subFont = New-Object System.Drawing.Font $fontFamily, 42, ([System.Drawing.FontStyle]::Regular), ([System.Drawing.GraphicsUnit]::Pixel)
$smallFont = New-Object System.Drawing.Font $fontFamily, 34, ([System.Drawing.FontStyle]::Regular), ([System.Drawing.GraphicsUnit]::Pixel)

$format = New-Object System.Drawing.StringFormat
$format.Alignment = [System.Drawing.StringAlignment]::Center
$format.LineAlignment = [System.Drawing.StringAlignment]::Center

$titleLines = @("我在异界", "做黑心巨擘")
$shadowBrush = Brush 0 0 0 210
$goldBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
  (New-Object System.Drawing.Rectangle 180, 120, 1240, 430),
  ([System.Drawing.Color]::FromArgb(255, 255, 230, 155)),
  ([System.Drawing.Color]::FromArgb(255, 180, 55, 28)),
  90
)

for ($i = 0; $i -lt $titleLines.Count; $i++) {
  $rShadow = New-Object System.Drawing.RectangleF 185, (135 + $i * 150), 1240, 150
  $rText = New-Object System.Drawing.RectangleF 180, (126 + $i * 150), 1240, 150
  $graphics.DrawString($titleLines[$i], $titleFont, $shadowBrush, $rShadow, $format)
  $graphics.DrawString($titleLines[$i], $titleFont, $goldBrush, $rText, $format)
}

$tagRect = New-Object System.Drawing.RectangleF 210, 2025, 1180, 70
$graphics.DrawString("矿奴开局 · 账册破局 · 命债成道", $subFont, (Brush 226 150 82 230), $tagRect, $format)

$quoteRect = New-Object System.Drawing.RectangleF 240, 2110, 1120, 62
$graphics.DrawString("旧规矩吃人，新规矩明码标价", $smallFont, (Brush 178 178 168 210), $quoteRect, $format)

# Border and vignette.
$graphics.DrawRectangle((Pen 221 80 34 160 8), 54, 54, $width - 108, $height - 108)
$graphics.DrawRectangle((Pen 255 199 96 80 2), 84, 84, $width - 168, $height - 168)

$vignette = New-Object System.Drawing.Drawing2D.GraphicsPath
$vignette.AddEllipse(-360, -300, $width + 720, $height + 600)
$region = New-Object System.Drawing.Region($rect)
$region.Exclude($vignette)
$graphics.FillRegion((Brush 0 0 0 135), $region)

$outPath = Join-Path $outDir "cover-wo-zai-yijie-zuo-heixin-jubo.png"
$bitmap.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)

$graphics.Dispose()
$bitmap.Dispose()
$bg.Dispose()
$ledgerBrush.Dispose()
$titleFont.Dispose()
$subFont.Dispose()
$smallFont.Dispose()
$fontCollection.Dispose()

Write-Output $outPath
