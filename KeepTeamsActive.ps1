# Prevent Teams from setting status to 'Away' by simulating mouse movement
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class MouseMover {
    [DllImport("user32.dll")]
    public static extern void mouse_event(int dwFlags, int dx, int dy, int dwData, int dwExtraInfo);
    public const int MOUSEEVENTF_MOVE = 0x0001;
    public static void MoveMouse() {
        mouse_event(MOUSEEVENTF_MOVE, 1, 0, 0, 0);
        mouse_event(MOUSEEVENTF_MOVE, -1, 0, 0, 0);
    }
}
"@

# Prevent screen from locking by disabling sleep temporarily
function Prevent-Sleep {
    powercfg -change -standby-timeout-ac 0  # Disable standby/sleep
}

# Restore the default sleep setting (after the script ends or if manually triggered)
function Restore-Sleep {
    powercfg -change -standby-timeout-ac 15  # Set to 15 minutes or your default timeout
}

# Set the interval in minutes to simulate activity
$intervalMinutes = 4

# Prevent sleep before starting the loop
Prevent-Sleep

Write-Host "Keeping Teams active. Press Ctrl+C to stop."

try {
    while ($true) {
        # Simulate mouse movement
        [MouseMover]::MoveMouse()
        Write-Host "Mouse moved to keep active at $(Get-Date)"
        Start-Sleep -Seconds ($intervalMinutes * 60)
    }
} catch {
    Write-Host "An error occurred: $_"
} finally {
    # Restore sleep settings when the script ends or is stopped
    Restore-Sleep
    Write-Host "Sleep settings restored."
}
