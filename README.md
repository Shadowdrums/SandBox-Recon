# SandBox-Recon
To find host device information through Windows Sandbox

# SandBox-Recon.ps1

## Overview

`SandBox-Recon.ps1` is a powerful PowerShell script crafted for network reconnaissance from within a Hyper-V Sandbox environment. This script is designed to gather critical network information, perform a public network port scan, and identify the host machine's local IP address by pinging local IP ranges. It is an essential tool for IT professionals and network administrators who need to perform detailed network diagnostics and assessments within a controlled environment.

## Features

### 1. Retrieve Local IP Address of the Sandbox VM
The script determines the local IP address assigned to the Virtual Machine (VM) within the sandbox environment. This is crucial for identifying the VM's network position and facilitating further network operations.

### 2. Identify Host Machine's IP Address
By examining the default gateway, the script retrieves the host machine's IP address. This feature is particularly useful for understanding the network topology and the relationship between the VM and the host machine.

### 3. Obtain Public IP Address
The script fetches the public IP address of the host device using an online service. This provides a clear view of the external network presence and is essential for conducting external network assessments.

### 4. Public Network Port Scan
The script performs a scan of common ports on the public IP address to identify open ports. This helps in assessing the security posture of the network by identifying potentially vulnerable open ports that could be exploited.

### 5. Ping Local IPs
The script pings local IP addresses in the `192.168.x.1` range to identify the host's local IP address. This function helps in mapping the local network and identifying active devices.

## Prerequisites

- **PowerShell**: Ensure you have PowerShell installed on your system.
- **Internet Access**: Required for retrieving the public IP address.

## Usage

Follow these steps to run the script:

### 1. Open PowerShell
Launch a PowerShell terminal with administrative privileges to ensure the script has the necessary permissions to perform its tasks.

### 2. Execute the Script
Run the `SandBox-Recon.ps1` script in the PowerShell terminal using the command:

```powershell```
.\SandBox-Recon.ps1

### 3. Monitor Progress
The script will display real-time progress in the terminal and save results to script_output.txt in the current working directory. This allows you to monitor the script's activities and review the results later.

### 4. Exit the Script
After the script completes its tasks, it will prompt you to press Enter to exit. This ensures that you have time to review the final output before closing the terminal.

## Detailed Functionality
The script encompasses several core functions, each designed to perform specific tasks:

- Get-SandboxLocalIP: Identifies and retrieves the local IP address of the Sandbox VM.
- Get-HostIPAddress: Determines the host machine's IP address via the default gateway.
- Get-PublicIPAddress: Obtains the public IP address of the host device through an external service.
- Scan-PublicNetwork: Conducts a port scan on the public IP to identify open ports.
- Ping-LocalIPs: Pings a range of local IP addresses to discover the host's local IP.
## Contribution
Contributions to this script are welcome. If you have suggestions for improvements or have found a bug, please create an issue or submit a pull request on GitHub.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Disclaimer
This script is provided as-is without any warranty. The user assumes all responsibility for any consequences resulting from its use. Ensure you have the necessary permissions and authorizations before performing network scans.

By utilizing SandBox-Recon.ps1, you gain a powerful tool for network reconnaissance and diagnostics, enhancing your ability to manage and secure network environments effectively.
