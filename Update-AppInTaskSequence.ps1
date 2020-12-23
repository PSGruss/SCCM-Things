###############################################
# Process to update an app in a task sequence #
# Using an 'Install Application' Task         #
###############################################
<#
  Code to connect to SCCM. Launch Powershell ISE from SCCM Console to find this code
#>
# Declare variables
$TS_Name = 'Name Of Task Sequence'
$TS_StepName = 'Name of Install Application Task'
$NewApp_Name = 'Name of New Application in SCCM'
$OldApp_Name = 'Name of Application to replace'

# Get the existing Install Application step
$TS_Get_Splat = @{
  TaskSequenceName = $TS_Name
  StepName = $TS_StepName
}
$TS = Get-CMTSStepInstallApplication @TS_Get_Splat

# Get application objects for all apps included in this step
$AllApps = $TS.AppInfo.DisplayName | foreach-object {Get-CMApplication -fast -name $_}

# Get application object for the new application
$NewApp = Get-CMApplication -fast -name $NewApp_Name

# Identify the app we're trying to replace, and replace it with the new app object
for ($i = 0; $i -lt $AllApps.Count; $i++) {
  if ($AllApps[$i].LocalizedDisplayName -like $OldApp_Name) {
    $AllApps[$i] = $NewApp
  }
}

# Set Task Sequence step with the new application list
$TS_Set_Splat = @{
  TaskSequenceName = $TS_Name
  StepName = $TS_StepName
  Application = $AllApps
}
Set-CMTSStepInstallApplication @TS_Splat
