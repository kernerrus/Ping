Add-Type -assembly System.Windows.Forms
$script_path	= "C:\Test";
$label_from_top = 10;

function get_status($PictureBox,$path_ip) {
if($path_ip){
	if ((Test-Connection -Count 2 -computer $path_ip -quiet) -eq $True) {
		$PictureBox.imageLocation	= $script_path + "\yes.png"
		}
	Else {
		$PictureBox.imageLocation 	= $script_path + "\no.png"
		}
}
else{
Write-Host "Хост не указан";
}
}

Function Create_line($label,$path_ip,$caption, $top) { 
if($path_ip){
	$label.Location	= New-Object System.Drawing.Point(1, $top)
	$label.text		= $path_ip+$caption
	$Label.AutoSize = $true
	}
}
Function Create_link($PictureBox,$path_ip, $top){ 
if($path_ip){
	$PictureBox.Width		= 10
	$PictureBox.Height		= 10
	$PictureBox.Location	= New-Object System.Drawing.Point(210,$top)
	$PictureBox.SizeMode	= [System.Windows.Forms.PictureBoxSizeMode]::zoom

	get_status -PictureBox $PictureBox -path_ip $path_ip
}
	}

$main_form			= New-Object System.Windows.Forms.Form
$main_form.Text		= 'Проверка доступности служб'
$main_form.Width	= 250
$main_form.Height	= 250
$main_form.AutoSize	= $true
$main_form.TopMost	= $true

$data=Get-Content -LiteralPath $script_path"\path.txt";
$line				= $data.Substring(0,47);
$i					= 0
$ip					= @()
$capt				= @()
$labels				= @()
$PictureBoxs		= @()
$len				= $data.Length;
while($i -lt $len){
if($data[$i].Length -gt 0){
	$f				= $data[$i].IndexOf("|")
	$l				= $data[$i].LastIndexOf("|")
	$ip				+= $data[$i].Substring(0,$f)
	$capt			+= $data[$i].Substring($f+1,$l-$f-1)
	$label_from_top += 15

	Create_line -label ($label_obj = New-Object System.Windows.Forms.Label) -path_ip $ip[$i] -caption $capt[$i] -top $label_from_top
	Create_link -PictureBox ($PictureBox_obj = New-Object system.Windows.Forms.PictureBox) -path_ip $ip[$i] -top $label_from_top
    $labels			+= $label_obj
	$PictureBoxs	+= $PictureBox_obj
	$main_form.Controls.Add($labels[$i])
	$main_form.Controls.Add($PictureBoxs[$i])
}
else{}
	$i 				+=1
}

$i					= 0
$Label0				= New-Object System.Windows.Forms.Label
$Label0.Text		= Get-Date
$Label0.Location	= New-Object System.Drawing.Point(80,180)
$Label0.AutoSize	= $true

$Button				= New-Object System.Windows.Forms.Button
$Button.Location	= New-Object System.Drawing.Size(100,200)
$Button.Size		= New-Object System.Drawing.Size(80,30)
$Button.Text		= "Reload"

$Button.Add_Click({
$i=0; 
			while($i -lt $len){
				get_status -PictureBox $PictureBoxs[$i] -path_ip $ip[$i]
				$i	+=1
				}

		$Label0.Text = Get-Date 
		}
	)

$main_form.Controls.Add($Button)
$main_form.Controls.Add($Label0)

$main_form.ShowDialog()