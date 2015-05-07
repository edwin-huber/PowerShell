# SAMPLE CODE:
# Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.
# THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
# PURPOSE. We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and 
# distribute the object code form of the Sample Code, provided that. You agree: (i) to not use Our name, logo, or
# trademarks to market Your software product in which the Sample Code is embedded; (ii) to include a valid copyright
# notice on Your software product in which the Sample Code is embedded; and (iii) to indemnify, hold harmless, and 
# defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees, that arise or result
# from the use or distribution of the Sample Code  
# ################################
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
