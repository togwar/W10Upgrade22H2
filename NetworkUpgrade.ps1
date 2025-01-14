# Configurações
$NetworkShare = "\\Servidor\Repositorio"    # Caminho do compartilhamento de rede
$ISOFile = "Windows10_22H2_x64.iso"         # Nome do arquivo ISO
$MountPoint = "Z:"                          # Letra da unidade para mapear o compartilhamento
$TempDir = "$env:TEMP\Windows10Upgrade"     # Pasta temporária para copiar arquivos (se necessário)

# Função para mapear o compartilhamento de rede
function Map-NetworkShare {
    param (
        [string]$SharePath,
        [string]$DriveLetter
    )
    if (!(Test-Path $DriveLetter)) {
        Write-Host "Mapeando compartilhamento de rede: $SharePath em $DriveLetter" -ForegroundColor Cyan
        New-PSDrive -Name $DriveLetter.Replace(":", "") -PSProvider FileSystem -Root $SharePath -Persist -ErrorAction Stop
    } else {
        Write-Host "Compartilhamento já mapeado." -ForegroundColor Green
    }
}

# Função para montar a ISO
function Mount-ISO {
    param (
        [string]$ISOPath
    )
    Write-Host "Montando a ISO: $ISOPath" -ForegroundColor Cyan
    $mountResult = Mount-DiskImage -ImagePath $ISOPath -ErrorAction Stop
    $driveLetter = (Get-Volume -DiskImagePath $ISOPath).DriveLetter
    return "$driveLetter`:"
}

# Função para executar o setup do Windows
function Perform-Upgrade {
    param (
        [string]$SetupPath
    )
    Write-Host "Iniciando atualização do Windows 10..." -ForegroundColor Cyan
    Start-Process -FilePath $SetupPath -ArgumentList "/auto upgrade /quiet /norestart" -Wait
    Write-Host "Atualização concluída. Verifique se o sistema precisa reiniciar." -ForegroundColor Green
}

# Fluxo principal
try {
    # Mapear o compartilhamento de rede
    Map-NetworkShare -SharePath $NetworkShare -DriveLetter $MountPoint

    # Caminho completo da ISO
    $ISOPath = Join-Path -Path $MountPoint -ChildPath $ISOFile

    # Montar a ISO
    $DriveLetter = Mount-ISO -ISOPath $ISOPath

    # Caminho para o setup.exe
    $SetupPath = Join-Path -Path $DriveLetter -ChildPath "setup.exe"

    # Executar o upgrade
    Perform-Upgrade -SetupPath $SetupPath

    # Desmontar a ISO
    Write-Host "Desmontando a ISO..." -ForegroundColor Cyan
    Dismount-DiskImage -ImagePath $ISOPath
} catch {
    Write-Host "Erro durante o processo: $_" -ForegroundColor Red
} finally {
    # Remover mapeamento de rede
    Write-Host "Removendo mapeamento de rede..." -ForegroundColor Cyan
    Remove-PSDrive -Name $MountPoint.Replace(":", "") -ErrorAction SilentlyContinue
}
