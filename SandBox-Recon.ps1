# Function to get the local IP address of the Windows Sandbox VM
function Get-SandboxLocalIP {
    $localIP = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "Loopback*" } | Select-Object -First 1 -ExpandProperty IPAddress
    return $localIP
}

# Function to get the host IP address via the default gateway
function Get-HostIPAddress {
    $hostIP = $null
    try {
        $gateway = Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null } | Select-Object -ExpandProperty IPv4DefaultGateway
        if ($gateway) {
            $hostIP = $gateway.IPAddressToString
        }
    } catch {
        Write-Output "Error getting host IP address via the default gateway: $_"
    }
    return $hostIP
}

# Function to get the public IP address of the host device
function Get-PublicIPAddress {
    try {
        $publicIP = Invoke-RestMethod -Uri "https://api.ipify.org" -UseBasicParsing
        return $publicIP
    } catch {
        Write-Output "Error getting public IP address: $_"
        return $null
    }
}

# Function to get all IP addresses of the VM
function Get-AllIPAddresses {
    $ips = @()
    try {
        $netIPs = Get-NetIPAddress | Where-Object { $_.AddressFamily -eq "IPv4" -or $_.AddressFamily -eq "IPv6" }
        foreach ($ip in $netIPs) {
            $ips += "$($ip.AddressFamily) Address: $($ip.IPAddress)"
        }
    } catch {
        Write-Output "Error getting all IP addresses of the VM: $_"
    }
    return $ips
}

# Function to perform a public network scan using PowerShell
function Scan-PublicNetwork {
    param (
        [string]$publicIP
    )

    $openPorts = @()
    Write-Host "Scanning public IP ($publicIP) for open ports..."

    $commonPorts = @(21, 22, 23, 25, 53, 80, 110, 123, 135, 139, 143, 443, 445, 993, 995, 3389)

    try {
        foreach ($port in $commonPorts) {
            $socket = New-Object Net.Sockets.TcpClient
            try {
                $socket.Connect($publicIP, $port)
                if ($socket.Connected) {
                    Write-Host "Open port found: $port"
                    $openPorts += $port
                }
            } catch {
                # Ignore connection failures
            } finally {
                $socket.Close()
            }
        }
    } catch {
        Write-Host "Error during public network scan: $_"
    }

    return $openPorts
}

# Function to ping local IPs starting with 192.168.x.1 until a reply is received/ scanning for Host Router
function Ping-LocalIPs {
    Write-Host "Pinging local IPs starting with 192.168.x.1..."
    $replyIP = $null
    for ($x = 0; $x -lt 256; $x++) {
        $ip = "192.168.$x.1"
        if (Test-Connection -ComputerName $ip -Count 2 -Quiet) {
            $replyIP = $ip
            Write-Host "Received reply from $ip"
            break
        }
    }
    return $replyIP
}

# Function to provide live progress and save to file
function Show-ProgressAndSave {
    param (
        [string[]]$output
    )
    $output | ForEach-Object { Write-Host $_ }
    $output | Out-File -FilePath "$PWD\script_output.txt" -Append
}

# Main function to show progress and wait for user input to exit
function Show-ProgressAndWait {
    $output = @()

    Write-Host "Retrieving IP addresses..."

    # Get local IP address of the Sandbox VM
    $localIP = Get-SandboxLocalIP
    if ($localIP) {
        $output += "Sandbox VM Local IP Address: $localIP"
    } else {
        $output += "Unable to determine Sandbox VM Local IP Address."
    }
    Show-ProgressAndSave -output $output
    $output = @()

    # Get host IP address
    $hostIP = Get-HostIPAddress
    if ($hostIP) {
        $output += "Host IP Address: $hostIP"
    } else {
        $output += "Unable to determine Host IP Address."
    }
    Show-ProgressAndSave -output $output
    $output = @()

    # Get public IP address of the host device
    $publicIP = Get-PublicIPAddress
    if ($publicIP) {
        $output += "Public IP Address of Host Device: $publicIP"
    } else {
        $output += "Unable to determine Public IP Address of Host Device."
    }
    Show-ProgressAndSave -output $output
    $output = @()

    # Perform a public network scan using PowerShell
    if ($publicIP) {
        $openPorts = Scan-PublicNetwork -publicIP $publicIP
        if ($openPorts) {
            $output += "Open ports found on the public IP:"
            foreach ($port in $openPorts) {
                $output += "Port $port"
            }
        } else {
            $output += "No open ports found on the public IP."
        }
    } else {
        $output += "Skipping public network scan due to inability to determine public IP address."
    }
    Show-ProgressAndSave -output $output
    $output = @()

    # Ping local IPs to find host IP
    $replyIP = Ping-LocalIPs
    if ($replyIP) {
        $output += "Host Local IP Address: $replyIP"
    } else {
        $output += "Unable to determine Host Local IP Address."
    }
    Show-ProgressAndSave -output $output

    # Wait for user input to exit
    Write-Host "Press Enter to exit."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Call the main function to show progress and wait for user input
Show-ProgressAndWait
