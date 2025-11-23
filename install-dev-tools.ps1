<#
.SYNOPSIS
    Installs a list of development applications using the Chocolatey (choco) package manager.

.DESCRIPTION
    This script automates the installation of a predefined list of software for developer 'bunnydevv'.
    It exclusively uses Chocolatey and provides progress updates in the terminal as each application is installed.

    Instructions:
    1. Ensure Chocolatey is installed on your system.
    2. Review the list of applications and comment out any you don't wish to install.
    3. Run this script from an elevated PowerShell terminal.

.NOTES
    Author: bunnydevv
    Last Updated: 2025-11-23
    - Run PowerShell as an Administrator to prevent permission errors.
    - The '-y' flag is used to automatically confirm all installation prompts.
#>

Write-Host "==================================================" -ForegroundColor Green
Write-Host "         DEV ENVIRONMENT SETUP FOR bunnydevv        " -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
Write-Host "This script will install applications using Chocolatey (choco)." -ForegroundColor Yellow
Write-Host "Please ensure Chocolatey is installed before running." -ForegroundColor Yellow
Write-Host ""

# --------------------------------------------------------------------------
# Define the list of applications to install via Chocolatey
# --------------------------------------------------------------------------
# To skip an application, simply comment it out with a '#'
$appsToInstall = @{
    # --- JetBrains IDEs ---
    "rider"                      = ""
    "goland"                     = ""
    "pycharm-professional"       = "" # Use 'pycharm-community' for the community edition
    "rustrover"                  = ""
    "webstorm"                   = ""
    "datagrip"                   = ""
    "dataspell"                  = ""

    # --- .NET SDKs ---
    # NOTE: 'dotnet-sdk' installs the latest version, which might be a preview.
    "dotnet-sdk"                 = "" # Installs .NET 9 (latest)
    "dotnet-8.0-sdk"             = ""
    "dotnet-6.0-sdk"             = ""

    # --- Visual Studio & SQL Server ---
    # The Visual Studio installation can be customized with --package-parameters
    "visualstudio2022enterprise" = "--package-parameters ""--add Microsoft.VisualStudio.Workload.ManagedDesktop --add Microsoft.VisualStudio.Workload.NetWeb --includeRecommended"""
    "sql-server-2022"            = ""
    "sql-server-management-studio" = ""

    # --- Editors and Runtimes ---
    "vscode"                     = ""
    "golang"                     = ""
    "python"                     = "" # Installs the latest Python 3
}

# --------------------------------------------------------------------------
# Installation Process
# --------------------------------------------------------------------------
$totalApps = $appsToInstall.Keys.Count
$installedCount = 0

Write-Host "Starting installation of $totalApps applications..." -ForegroundColor Cyan
Write-Host "--------------------------------------------------"

foreach ($app in $appsToInstall.Keys) {
    $installedCount++
    $progress = "[{0}/{1}]" -f $installedCount, $totalApps
    $params = $appsToInstall[$app]
    
    Write-Host ""
    Write-Host "$progress Installing '$app'..." -ForegroundColor White
    
    # Check if the package is already installed
    choco list --local-only --exact $app | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$progress '$app' is already installed. Skipping." -ForegroundColor Green
        continue
    }

    # Install the app with its specific parameters
    $command = "choco install $app -y $params"
    Write-Host "Running command: $command"
    Invoke-Expression $command
    
    # Verify installation and provide feedback
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$progress Successfully installed '$app'." -ForegroundColor Green
    } else {
        Write-Host "$progress ERROR: Failed to install '$app'. Please check the output above." -ForegroundColor Red
    }
    Write-Host "--------------------------------------------------"
}

Write-Host ""
Write-Host "✅ All installations complete. Please review the output for any errors." -ForegroundColor Green
