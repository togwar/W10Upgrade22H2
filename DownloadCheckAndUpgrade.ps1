# Diretório para armazenar o instalador da atualização
$UpgradeDir = "$PSScriptRoot\Windows10Upgrade"

# URL do Media Creation Tool ou ISO da 22H2 (modifique conforme necessário)
$UpgradeToolURL = "https://go.microsoft.com/fwlink/?LinkID=799445"

# Verifica a versão atual do Windows
function Check-WindowsVersion {
    $currentBuild = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild
    if ($currentBuild -ge 19045) {
        Write-Host "O dispositivo já está na versão 22H2 ou superior." -ForegroundColor Green
        return $true
    } else {
        Write-Host "O dispositivo precisa de atualização para o Windows 10 22H2." -ForegroundColor Yellow
        return $false
    }
}

# Valida os requisitos do sistema
function Validate-Prerequisites {
    $diskSpace = (Get-PSDrive -Name C).Free / 1GB
    if ($diskSpace -lt 20) {
        Write-Host "Espaço em disco insuficiente. Requer pelo menos 20 GB livres no disco C:." -ForegroundColor Red
        return $false
    }
    Write-Host "Requisitos de sistema atendidos." -ForegroundColor Green
    return $true
}

# Baixa o Media Creation Tool
function Download-UpgradeTool {
    if (!(Test-Path -Path $UpgradeDir)) {
        New-Item -ItemType Directory -Path $UpgradeDir | Out-Null
    }
    $toolPath = "$UpgradeDir\MediaCreationTool22H2.exe"
    if (!(Test-Path -Path $toolPath)) {
        Write-Host "Baixando o Media Creation Tool..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $UpgradeToolURL -OutFile $toolPath
    } else {
        Write-Host "Media Creation Tool já está disponível em $toolPath." -ForegroundColor Green
    }
    return $toolPath
}

# Executa o Media Creation Tool para atualizar
function Perform-Upgrade {
    param (
        [string]$ToolPath
    )
    Write-Host "Executando o Media Creation Tool para atualização..." -ForegroundColor Cyan
    Start-Process -FilePath $ToolPath -ArgumentList "/auto upgrade /quiet /norestart" -Wait
    Write-Host "Atualização concluída. Pode ser necessário reiniciar o sistema." -ForegroundColor Green
}

# Fluxo principal
Write-Host "Iniciando automação de upgrade para Windows 10 22H2..." -ForegroundColor Cyan

if (-not (Check-WindowsVersion)) {
    if (Validate-Prerequisites) {
        $toolPath = Download-UpgradeTool
        Perform-Upgrade -ToolPath $toolPath
    } else {
        Write-Host "Requisitos do sistema não atendidos. Abandonando o processo de atualização." -ForegroundColor Red
    }
}
