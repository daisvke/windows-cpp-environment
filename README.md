# windows-cpp-environment

## Introduction

This README explains how to set up a Windows development environment for C and C++ projects. It covers installing Visual Studio Build Tools, configuring `nmake` and `cl`, setting up Visual Studio Code to use the proper environment, customizing PowerShell with useful aliases, and creating a safe sandbox environment for testing programs in isolation. The instructions are suitable for software development and research scenarios where you want to avoid affecting your main system.

### Table of Contents

- [Setting up Windows](#setting-up-windows)  
  - [Install Build Tools (CL, NMAKE)](#install-build-tools-cl-nmake)  
  - [Add right-click “Open VS Build Tools here”](#add-right-click-open-vs-build-tools-here)  
  - [How to use `nmake` in VS Code](#how-to-use-nmake-in-vs-code)  
  - [`nmake` and cmd.exe](#nmake-and-cmdexe)  
  - [Setting up PowerShell](#setting-up-powershell)  
- [Setting up a Windows Sandbox for Safe Testing](#setting-up-a-windows-sandbox-for-safe-testing)  
  - [Launching Windows Sandbox](#launching-windows-sandbox)  
  - [Windows Sandbox configuration (`WindowsSandboxConfigFile.wsb`)](#windows-sandbox-configuration-windowssandboxconfigfilewsb)  
  - [Startup initialization script (`setup-lang.ps1`)](#startup-initialization-script-setup-langps1)  

---

## Setting up Windows

### Install Build Tools (CL, NMAKE)

1. **Download the Build Tools for Visual Studio**:

   * Go to the official Microsoft download page:
    [https://visualstudio.microsoft.com/downloads/](https://visualstudio.microsoft.com/downloads/)
   * Scroll all the way down to **“Tools for Visual Studio”**.
   * Click **“Build Tools for Visual Studio”** and download it.

2. **Install only required components**:

   * Run the installer.
   * Select the **“desktop development with C++”** workload.
   * Ensure these components are checked:
     * MSVC v142 or later (C++ build tools)
     * Windows 10 SDK
     * **C++ CMake tools for Windows**
     * **Windows SDK for Windows 10**
   * Click Install.

  If Microsoft.VisualCpp.Redist.14 installation fails, follow the steps on:
    https://developercommunity.visualstudio.com/t/PackageId:MicrosoftVisualCppRedist14;/10902964

3. **Launch Developer Command Prompt**:

   * After installation, search for **“x64 Native Tools Command Prompt for VS”** in Start Menu.
   * This sets all environment variables, including for `nmake`.

4. **Verify installation**:

   ```cmd
   nmake /?
   ```

   You should see the help menu for NMAKE.

---

### Add right-click “Open VS Build Tools here”

1. Open Notepad
2. Paste the following (adjust path if needed):

```reg
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\Directory\Background\shell\VS2022_x64_Tools]
@="Open VS 2022 x64 Tools Here"

[HKEY_CLASSES_ROOT\Directory\Background\shell\VS2022_x64_Tools\command]
@="\"C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\VC\\Auxiliary\\Build\\vcvars64.bat\" && cmd.exe"
```

3. Save it as `vs-tools-here.reg`
4. Double-click to add it to your registry.

Now right-click any folder background > **“Open VS 2022 x64 Tools Here”**.

---

### How to use `nmake` in VS Code

#### Method 1

To use `nmake` from within **VS Code**, launch it from the **x64 Native Tools Command Prompt**:

1. Open **"x64 Native Tools Command Prompt for VS 2022"**
2. Navigate to your project folder:

   ```cmd
   cd path\to\your_project
   ```
3. Launch VS Code:

   ```cmd
   code .
   ```

The integrated terminal in VS Code will inherit the environment (`cl`, `nmake`, etc.).

#### Method 2

Configure VS Code to run **cmd.exe** with the environment set by **`vcvars64.bat`**:

1. Open Settings:
   - Go to **File > Preferences > Settings** (or `Ctrl + ,`)
2. Search for **Integrated Terminal**
3. Edit `settings.json` to add a custom terminal profile:

```json
"terminal.integrated.profiles.windows": {
    "cmd with VS": {
        "path": "C:\\Windows\\System32\\cmd.exe",
        "args": [
            "/k",
            "C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\VC\\Auxiliary\\Build\\vcvars64.bat"
        ],
        "icon": "terminal"
    }
},
"terminal.integrated.defaultProfile.windows": "cmd with VS"
```

You can now launch `cmd with VS` as a terminal profile inside VS Code.

---

### `nmake` and cmd.exe

- `nmake` uses **cmd.exe syntax**, not PowerShell.  
- Commands like `del` and `copy` work in Makefiles, but PowerShell commands like `Remove-Item` will not.

---

### Setting up PowerShell

#### Adding aliases

1. Open the PowerShell profile:

```powershell
notepad $PROFILE
```

2. Add useful aliases as functions:

```powershell
# Git shortcuts
function gst { git status }
function gph { git push }  # 'gp' is already taken
function ga { git add $args }
function gcmsg { git commit -m $args }
```

3. Save and reload the profile:

```powershell
. $PROFILE
```

---

## Setting up a Windows Sandbox for Safe Testing

When developing or testing programs that should not run on your main system, it is recommended to use an isolated environment. Windows Sandbox provides a disposable virtual machine that resets every time it closes.

The repository includes two files that demonstrate how to prepare such an environment:

- `WindowsSandboxConfigFile.wsb`  
- `setup-lang.ps1`

These files show how to configure a sandbox, map a working folder, disable networking, and perform automated initialization steps.

---

### Launching Windows Sandbox

1. **Windows version requirement**: Windows 10 Pro, Enterprise, or Education (version 1903 or later) or Windows 11 Pro/Enterprise.  
2. **Enable Windows Sandbox feature**:
   - Go to **Control Panel > Programs > Turn Windows features on or off**
   - Check **Windows Sandbox**
   - Click **OK** and reboot if required
3. **Start the sandbox**:
   - Double-click the `WindowsSandboxConfigFile.wsb` file included in the repository
   - This will launch Windows Sandbox with the configured environment
   - The mapped folder and startup script will run automatically

---

### Windows Sandbox configuration (`WindowsSandboxConfigFile.wsb`)

This file defines how the sandbox behaves on startup. It demonstrates how to:

- Map a host directory into the sandbox (example path: `C:\path\to\my\host-folder`)  
- Disable networking for isolation  
- Automatically run a PowerShell script when the sandbox launches  
- Open Explorer and PowerShell inside the mapped folder for immediate testing  

Paths can be adapted to any directory you use for testing.

---

### Startup initialization script (`setup-lang.ps1`)

The PowerShell script referenced by the `.wsb` file runs automatically when the sandbox starts. In this repository, it is used as an example of:

- Performing initial setup tasks  
- Configuring system or user preferences inside the sandbox  
- Writing a log file to the mapped folder  
- Preparing a reproducible environment before testing  

You can replace its content with any initialization logic needed for your own environment.
