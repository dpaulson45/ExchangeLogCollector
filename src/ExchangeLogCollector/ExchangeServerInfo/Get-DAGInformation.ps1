Function Get-DAGInformation {
param(
    [Parameter(Mandatory=$true)][string]$DAGName
)
<#
    $dagName = Get-ExchangeServerDAGName -Server $env:COMPUTERNAME #only going to get the local server's DAG info
    if ($null -ne $dagName) {
        $dagObj = New-Object PSCustomObject
        $value = Get-DatabaseAvailabilityGroup $dagName -Status
        $dagObj | Add-Member -MemberType NoteProperty -Name DAGInfo -Value $value
        $value = Get-DatabaseAvailabilityGroupNetwork $dagName
        $dagObj | Add-Member -MemberType NoteProperty -Name DAGNetworkInfo -Value $value
        $dagObj | Add-Member -MemberType NoteProperty -Name AllMdbs -Value (Get-MailboxDatabaseInformationFromDAG -DAGInfo $dagObj.DAGInfo)
        return $dagObj
    }
#>
    try{
        $dag = Get-DatabaseAvailabilityGroup $DAGName -Status -ErrorAction Stop
    } catch {
        Write-ScriptDebug("Failed to run Get-DatabaseAvailabilityGroup on $DAGName")
        Invoke-CatchBlockActions
    }

    try {
        $dagNetwork = Get-DatabaseAvailabilityGroupNetwork $DAGName -ErrorAction Stop
    } catch {
        Write-ScriptDebug("Failed to run Get-DatabaseAvailabilityGroupNetwork on $DAGName")
        Invoke-CatchBlockActions
    }

    return [PSCustomObject]@{
        DAGInfo = $dag
        DAGNetworkInfo = $dagNetwork
        AllMbs = (Get-MailboxDatabaseInformationFromDAG -DAGInfo $dag)
    }
}