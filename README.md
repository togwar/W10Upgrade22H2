# W10Upgrade22H2

# Etapas da Solução
## 1. Verificação da Versão do Windows
  - Determine se o dispositivo já está na versão 22H2 ou se precisa de atualização.
  - Isso pode ser feito verificando o BuildNumber ou ReleaseID do Windows.

## 2. Validação de Pré-Requisitos
 - Certifique-se de que o dispositivo atenda aos requisitos para o upgrade:
 - Espaço em disco suficiente (pelo menos 20 GB recomendados).
 - Arquitetura compatível (x64 ou x86).
 - Atualizações de Servicing Stack e SHA-2 instaladas (especialmente em versões mais antigas).

## 3. Execução do Upgrade
 - Use o Media Creation Tool, Windows Update Assistant, ou diretamente um instalador offline via ISO para realizar o upgrade.

----------------------------------------------------------------------------------------------------

# DownloadCheckAndUpgrade.ps1 - Como Funciona o Script
## Verificação de Versão:
 - Compara o número de build atual do sistema (CurrentBuild) com o da versão 22H2 (19045).

## Pré-Requisitos:
 - Confirma se há pelo menos 20 GB de espaço livre no disco C:.

## Download do Media Creation Tool:
 - Baixa o Media Creation Tool para realizar a atualização, caso ainda não esteja disponível.

## Execução do Upgrade:
 - Executa o Media Creation Tool com argumentos automáticos e silenciosos (/auto upgrade /quiet /norestart).
