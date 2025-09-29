Add-Type -AssemblyName System.Windows.Forms

# Окно
$form = New-Object System.Windows.Forms.Form
$form.Text = "Комментарий к коммиту"
$form.Width = 500
$form.Height = 400

# Многострочный TextBox
$box = New-Object System.Windows.Forms.TextBox
$box.Multiline = $true
$box.Width = 460
$box.Height = 300
$box.ScrollBars = "Vertical"
$form.Controls.Add($box)

# Кнопка OK
$ok = New-Object System.Windows.Forms.Button
$ok.Text = "OK"
$ok.Width = 100
$ok.Height = 30
$ok.Top = 310
$ok.Left = 180
$ok.Add_Click({$form.Close()})
$form.Controls.Add($ok)

# Показываем окно
$form.ShowDialog() | Out-Null
$commitmsg = $box.Text

if ([string]::IsNullOrWhiteSpace($commitmsg)) {
    [System.Windows.Forms.MessageBox]::Show("Комментарий не введён. Прерывание.","Ошибка")
    exit 1
}

# Сохраняем текст во временный файл (чтобы работали переносы строк)
$tempFile = [System.IO.Path]::GetTempFileName()
Set-Content -Path $tempFile -Value $commitmsg -Encoding UTF8

git add .
git commit -F $tempFile
git push
py -m mkdocs gh-deploy

Remove-Item $tempFile
