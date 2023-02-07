#$global:RootPath = split-path -parent $MyInvocation.MyCommand.Definition
#Write-Host "$RootPath";
try {
    #--init
    $global:ErrorActionPreference = "Stop"
    $global:RootPath = split-path -parent $MyInvocation.MyCommand.Definition
    $global:json = Get-Content "$RootPath\config.json" -Raw | ConvertFrom-Json 
  

    [System.Windows.Forms.Application]::EnableVisualStyles();

    #---init>gui-util   
        Add-Type -AssemblyName System.Windows.Forms,System.Drawing
        Add-Type -AssemblyName PresentationCore,PresentationFramework
        $global:YesNoButton = [System.Windows.MessageBoxButton]::YesNo
        $global:OKButton = [System.Windows.MessageBoxButton]::OK
        $global:InfoIcon = [System.Windows.MessageBoxImage]::Information
        $global:WarningIcon = [System.Windows.MessageBoxImage]::Warning
        $global:ErrorIcon = [System.Windows.MessageBoxImage]::Error
        $global:QButton = [System.Windows.MessageBoxImage]::Question
        $IconImage = New-Object system.drawing.icon ("$RootPath\design\icon.ico")

     #--Add Gif file
    $file = (get-item "$RootPath\design\mochi-mochi-peach-cat-cat.gif")
    $file2 = (get-item "$RootPath\design\logo.png")
    $icon = [System.Drawing.Image]::Fromfile($file2);
    $img = [System.Drawing.Image]::Fromfile($file);
    

    function global:Get-Kill {
        param (
            $Mode
        )
        if ($Mode -eq "Hard") {
            $e = $_.Exception.GetType().FullName
            $line = $_.InvocationInfo.ScriptLineNumber
            $msg = $_.Exception.Message
            Write-Output "$(Get-Date -Format "HH:mm")[Error]: Initialization failed at line [$line] due [$e] `n`nwith details `n`n[$msg]`n"
            Write-Output "`n`n------------------END ROOT-------------------------"
            Stop-Transcript | Out-Null
            ClearCreateCSV
            exit
        }else{
            Write-Output "`n`n------------------END ROOT-------------------------"
            Stop-Transcript | Out-Null
            ClearCreateCSV
            exit
        }
        
    }
    
    function global:ClearCreateCSV {
        Remove-Item -Path "$RootPath\create.csv"
        New-Item $RootPath\create.csv -ItemType File | Out-Null
        Set-Content $RootPath\create.csv 'Name,Purpose,Members'   
    }

    Start-Transcript -Path "$RootPath\Toolbox_localtime_$(Get-Date -Format "MMddyyyyHHmm").txt" | Out-Null
    
    Write-Output "`n`n------------------BEGIN ROOT-------------------------"
    Write-Output "$(Get-Date -Format "HH:mm")[Log]: Form init success"
    
    #--form
    #---form-assembly
    $form = New-Object Windows.Forms.Form -Property @{
        Size = New-Object System.Drawing.Size(800,900)
        Text = "$($json.ToolName) $($json.ToolVersion)"
        StartPosition = 'CenterScreen'
        BackColor = $json.ToolUIBackColor
        FormBorderStyle = 'Fixed3D'
        #Icon = New-Object System.Drawing.Icon ('C:\Users\BoiserR\OneDrive - FUJITSU\Desktop\PowerShellNew\ClassAfternoon-Toolbox\design\icon.ico')
        Icon = $IconImage
    }
    $lblTOA = New-Object System.Windows.Forms.Label -Property @{
        Location = New-Object System.Drawing.Point(230,80)
        Size = New-Object System.Drawing.Size(290,150)
        ForeColor = $json.ToolUILabelColorDark
        BackColor = $json.ToolUIBackColorDark
        Text = "$($json.ToolTOAText)"
    }


    $btnStart = New-Object System.Windows.Forms.Button -Property @{
        Location = New-Object System.Drawing.Point(300,240)
        Size = New-Object System.Drawing.Size(125,50)
        ForeColor = $json.ToolUILabelColor
        BackColor = $json.ToolUIBtnColor
        Text = 'START'      
    }

    $btnStart.Add_Click({
        Write-Host "$(Get-Date -Format "HH:mm")[Log]: TOA confirm success"
        $btnStart.Hide()
        $lblTOA.Hide()
        $form.Size = New-Object System.Drawing.Size(400,400)
        $form.Location = New-Object System.Drawing.Point(700,350)
        $form.Controls.Add($shpDivider)
        $form.Controls.Add($lblMainMenu)
        $form.Controls.Add($btnCreate)
        $form.Controls.Add($btnRead)
        $form.Controls.Add($btnUpdate)
        $form.Controls.Add($btnDelete)
        $form.Controls.Remove($pictureBox)
        $form.controls.add($iconLabel)
        If ($objTypeCheckbox.Checked -eq $true)
        {
           $json.ToolShowTOA = "True"
           $vartest = "True"
           $json | ConvertTo-Json | Out-File "$RootPath\config.json"
        }
        if($objTypeCheckbox.Checked -ne $true){
            $json.ToolShowTOA = "False"
            $vartest = "False"
            $json | ConvertTo-Json | Out-File "$RootPath\config.json"
        }
        Write-Host "$vartest"
    })

    $shpDivider = New-Object System.Windows.Forms.Label -Property @{
        Location = New-Object System.Drawing.Point(30,50)
        Size = New-Object System.Drawing.Size(400,2)
        Text = ""
        BorderStyle = 'Fixed3D'
    }
    $lblMainMenu = New-Object System.Windows.Forms.Label -Property @{
        Location = New-Object System.Drawing.Point(30,30)
        Size = New-Object System.Drawing.Size(280,20)
        Font = New-Object System.Drawing.Font("Microsoft Sans Serif",9,[System.Drawing.FontStyle]::Bold)
        Text = "Group Management Tools"
    }
    $btnCreate = New-Object System.Windows.Forms.Button -Property @{
        Location = New-Object System.Drawing.Point(30,70)
        Size = New-Object System.Drawing.Size(125,50)
        ForeColor = $json.ToolUILabelColor
        BackColor = $json.ToolUIBtnColor
        Text = 'CREATE'      
    }

    $btnCreate.Add_Click({
        Write-Host "$(Get-Date -Format "HH:mm")[Log]: CREATE selected"
        Import-Module "$RootPath\create.ps1" -Force
        Write-Host "$(Get-Date -Format "HH:mm")[Log]: CREATE function imported"
        CreateDL
        Write-Host "`n`n$(Get-Date -Format "HH:mm")[Log]: CREATE function completed"
        [System.Windows.MessageBox]::Show("CREATE function completed","$($json.ToolName) $($json.ToolVersion)",$OKButton,$InfoIcon)
   
    })


    $btnRead = New-Object System.Windows.Forms.Button -Property @{
        Location = New-Object System.Drawing.Point(175,70)
        Size = New-Object System.Drawing.Size(125,50)
        ForeColor = $json.ToolUILabelColor
        BackColor = $json.ToolUIBtnColor
        Text = 'READ'      
    }
    $btnUpdate = New-Object System.Windows.Forms.Button -Property @{
        Location = New-Object System.Drawing.Point(30,140)
        Size = New-Object System.Drawing.Size(125,50)
        ForeColor = $json.ToolUILabelColor
        BackColor = $json.ToolUIBtnColor
        Text = 'UPDATE'      
    }
    $btnDelete = New-Object System.Windows.Forms.Button -Property @{
        Location = New-Object System.Drawing.Point(175,140)
        Size = New-Object System.Drawing.Size(125,50)
        ForeColor = $json.ToolUILabelColor
        BackColor = $json.ToolUIBtnColor
        Text = 'DELETE'      
    }

        [System.Windows.Forms.Application]::EnableVisualStyles();
        $iconLabel = new-object Windows.Forms.PictureBox
        $iconLabel.Location = New-Object System.Drawing.Size(120,280)
        $iconLabel.Size = New-Object System.Drawing.Size(120,50)
        $iconLabel.Image = $icon

        $pictureBox = new-object Windows.Forms.PictureBox
        $pictureBox.Location = New-Object System.Drawing.Size(120,400)
        $pictureBox.Size = New-Object System.Drawing.Size(700,700)
        $pictureBox.Image = $img
        $form.controls.add($pictureBox)

            $objTypeCheckbox = New-Object System.Windows.Forms.Checkbox 
            $objTypeCheckbox.Location = New-Object System.Drawing.Size(10,220) 
            $objTypeCheckbox.Size = New-Object System.Drawing.Size(500,20)
            $objTypeCheckbox.Text = "Bypass TOA"
            $objTypeCheckbox.TabIndex = 4
   
    #---form-render

    if ($json.ToolShowTOA -eq "True") {
        $form.Controls.Add($lblTOA)
    }
    $form.Controls.Add($objTypeCheckbox)
    $form.Controls.Add($btnStart)
    $form.ShowDialog() | Out-Null
    #$form.Icon = $objIcon
   
    Get-Kill 
}
catch {
    Get-Kill -Mode "Hard"
}