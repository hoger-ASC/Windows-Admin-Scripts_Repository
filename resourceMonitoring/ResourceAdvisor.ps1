# Script that retrieves resource usage bottlenecks

$Computer = Read-Host "Enter the computer name to monitor"

function Get-ResourceMetrics {
    $samples = (Get-Counter -Counter @(
        '\Processor(_Total)\% Processor Time',
        '\Memory\% Committed Bytes In Use',
        '\Network Interface(*)\Bytes Total/sec'
    )).CounterSamples

    $metrics = [ordered]@{
        CPU     = 0.0
        Memory  = 0.0
        Network = 0.0   # bytes/sec, summed across NICs
    }

    foreach ($s in $samples) {
        switch -Wildcard ($s.Path) {
            '*\processor(_total)\% processor time'     { $metrics.CPU    = [math]::Round($s.CookedValue, 2) }
            '*\memory\% committed bytes in use'        { $metrics.Memory = [math]::Round($s.CookedValue, 2) }
            '\network interface()\bytes total/sec'   { $metrics.Network += $s.CookedValue }
        }
    }
    $metrics
}

$Output = Get-ResourceMetrics
$Limit = 90

if ($Output.CPU  -gt $Limit) {
	"CPU bottleneck: $($Output.CPU)%"
} else {
	"CPU is operating below limit: $($Output.CPU)%"
}
if ($Output.Memory -gt $Limit) {
	"Memory bottleneck: $($Output.Memory)%"
} else {
	"Memory usage is below limit: $($Output.Memory)%"
if ($Output.Network -gt $Limit) {
	"Internet bandwidth bottleneck: $($Output.Network)%"
} else {
	"Network bandwidth usage is below limit: $($Output.Network)%"
