# Intersystem Docker

## Purpose

There are a few possible purposes:

1. Licence cpu restrictions
1. Containerization on local machine (For whatever reason)
1. Spin up multiple instances with ease on one machine
1. Use a setup script to setup your system

## System Requirements

NB! Only been tested with [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install-manual)

1. [Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. [Valid WRC account](https://wrc.intersystems.com/)
3. [Choclately](https://chocolatey.org/)
4. [Make](https://www.gnu.org/software/make/)

## WSL install steps

1. When you are installing docker desktop you shall see it recommends using `wsl` instead of `Hyper-V`. Please choose that option
2. You will need to update your kernel, you can do so by [downloading this](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)
3. You will need to install chocolately, this can be achieved by running the following: (Run windows terminal as administrator)
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

```
For example:
```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Install the latest PowerShell for new features and improvements! https://aka.ms/PSWindows

PS C:\Users\AwesomeUser> Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

```
4. Now we need to install [Make](https://www.gnu.org/software/make/)
```powershell
choco install make
```

## How to use?

1. [Download the version of ensemble you wish to use](https://wrc.intersystems.com/wrc/coDistEns.csp) into `/ensemble`
2. Update the Dockerfile with the version you downloaded
```Dockerfile
ARG cache=ensemble-2018.1.7.721.0
```
3. In the root of the folder run the following command to build your ensemble image
```powershell
make build BUILD_ENV=ensemble
```
4. Make sure you have logged into the [WRC](https://wrc.intersystems.com/) in order to download IRIS
    1. If you don't have a valid [WRC](https://wrc.intersystems.com/) account, you can use the community images, I will leave that to you to find
5. Make sure to copy your `cache.key` and `iris.key` into their respective folders.
6. Assuming everything is done you can now run `docker-compose up -d` or `make launch`
7. Next you will need to follow the setup script steps

## Setup install script

### Required

1. Editor of your choice
2. Some understanding of the [InstallManifest](https://docs.intersystems.com/latest/csp/docbook/DocBook.UI.Page.cls?KEY=GCI_manifest)

### What do I do?

1. Edit the `Installer.cls` in the desired environment folder with the variables you wish
2. Save the file
3. Run the command to "install" the system
```powershell
# For iris
make install BUILD_ENV=iris
# For ensemble
make install BUILD_ENV=ensemble
```
4. You *MIGHT* run into a permission issue with either system, in which case you can run
```powershell
# For iris
make fixperms BUILD_ENV=iris
# For ensemble
make fixperms BUILD_ENV=ensemble
```

# Important variables

In my version of this system the important variables to note are:

## IRIS

Web portal: 57773

Studio: 1973

## Ensemble

Web portal: 57772

Studio: 1972