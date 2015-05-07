# This script moves all Exchange 2013 public folders in a particular PF MAILBOX
# designated as $sourceMailbox to a target mailbox designated as $targetMailbox
# There is minimal error checking, and the limits of this script have not yet
# been tested.
# Use at your own risk.

$targetMailbox = "PFMB2"
$sourceMailbox = "PFMB1" 
write-host "Fetching folders from mailbox ... "
$FoldersInPFMailbox = Get-PublicFolder -Mailbox $sourceMailbox -ResidentFolders -recurse 
$CommaSeparatedListOfPFs = ""
write-host "Adding folders to list..."
foreach($a in $FoldersInPFMailbox) {$CommaSeparatedListOfPFs = $CommaSeparatedListOfPFs + $a.Identity.ToString() + ","}
write-Host "Trimming unwanted chars off the ends..."
$CommaSeparatedListOfPFs = $CommaSeparatedListOfPFs.Remove($CommaSeparatedListOfPFs.Length -1, 1)
$CommaSeparatedListOfPFs = $CommaSeparatedListOfPFs.Remove(0, 2)
write-host "Moving these folders..."
write-host $CommaSeparatedListOfPFs
write-host "Creating move request for all folders in " $sourceMailbox " to " $targetMailbox
write-host $CommaSeparatedListOfPFs.ToString().Normalize()
read-host "Press any key to continue, ctrl + C to exit without making changes"
write-host "creating array"
[Microsoft.Exchange.Configuration.Tasks.PublicFolderIdParameter[]] $array = $CommaSeparatedListOfPFs.ToString().Normalize().Split(",")
New-PublicFolderMoveRequest -Folders $array -TargetMailbox $targetMailbox
